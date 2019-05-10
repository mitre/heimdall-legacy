class Profile < ApplicationRecord
  resourcify
  has_many :supports
  has_many :controls, dependent: :destroy
  has_and_belongs_to_many :evaluations
  has_many :groups
  has_many :aspects
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  accepts_nested_attributes_for :controls
  accepts_nested_attributes_for :supports
  accepts_nested_attributes_for :groups
  accepts_nested_attributes_for :aspects
  #validates_presence_of :name, :title, :sha256
  scope :recent, ->(num) { order(created_at: :desc).limit(num) }

  def filtered_controls(filters = nil)
    return controls if filters.nil?

    filtered_list = controls.select do |control|
      keep = false
      filters.each do |filter|
        control.nist_tags.each do |nist_tag|
          if nist_tag.match(filter.regex)
            keep = true
            break
          end
        end
        break if keep
      end
      keep
    end
    filtered_list
  end

  def to_jbuilder
    Jbuilder.new do |json|
      json.extract! self, :name, :title, :maintainer, :copyright,
                    :copyright_email, :license, :summary, :version
      json.depends depends, :name, :path
      json.supports(supports.collect { |support| support.to_jbuilder.attributes! })
      json.controls(controls.collect { |control| control.to_jbuilder.attributes! })
      json.groups(groups.collect { |group| group.to_jbuilder.attributes! })
      json.attributes(aspects.collect { |profile_attribute| aspects.to_jbuilder.attributes! })
      json.extract! self, :sha256
    end
  end

  def as_json
    to_jbuilder.attributes!
  end

  def to_json(*_args)
    to_jbuilder.target!
  end

  def is_editable?
    evaluations.empty?
  end

  def control_families
    families = []
    nist = {}
    controls.each do |control|
      control.tags.where(name: 'nist').each do |tag|
        tag.good_values.each do |value|
          nist[value] = [] unless nist[value]
          nist[value] << control
          families << value
        end
      end
    end
    [families, nist]
  end

  def nist_hash(cat)
    nist = {}
    controls.each do |control|
      severity = control.severity
      next unless severity && (cat.nil? || cat == severity)

      control.tags.where(name: 'nist').each do |tag|
        tag.good_values.each do |value|
          nist[value] = [] unless nist[value]
          nist[value] << { "name": control.control_id.to_s, "severity": severity, "impact": control.impact, "value": 1 }
        end
      end
    end
    nist
  end

  def self.parse(profiles)
    all_profiles = []
    profiles.try(:each) do |profile_hash|
      new_profile_hash = Profile.transform(profile_hash.deep_dup)
      aspects = new_profile_hash.delete('aspects') || []
      new_profile_hash[:aspects_attributes] = aspects
      all_profiles << new_profile_hash
    end
    all_profiles
  end

  def self.transform(hash)
    hash = hash.deep_transform_keys { |key| key.to_s.tr('-', '_').gsub(/\battributes\b/, 'aspects').gsub(/\bid\b/, 'control_id') }
    controls = Control.transform(hash.delete('controls'))
    hash[:controls_attributes] = controls
    supports = hash.delete('supports') || []
    new_supports = []
    supports.each do |key, value|
      new_supports << { 'name': key, 'value': value }
    end
    hash[:supports_attributes] = new_supports
    groups = hash.delete('groups') || []
    new_groups = []
    groups.each do |group|
      if group['title'].present? and group['controls'].size > 1
        new_groups << group
      end
    end
    hash[:groups_attributes] = new_groups if !new_groups.empty?
    hash
  end
end
