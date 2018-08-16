class Profile
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Userstamps::Model
  resourcify
  field :name, type: String
  field :title, type: String
  field :maintainer, type: String
  field :copyright, type: String
  field :copyright_email, type: String
  field :license, type: String
  field :summary, type: String
  field :version, type: String
  field :parent_profile, type: String
  field :sha256, type: String
  embeds_many :depends, cascade_callbacks: true
  embeds_many :supports, cascade_callbacks: true
  has_many :controls, dependent: :destroy
  has_and_belongs_to_many :evaluations
  embeds_many :groups, cascade_callbacks: true
  embeds_many :profile_attributes, cascade_callbacks: true
  accepts_nested_attributes_for :depends
  accepts_nested_attributes_for :controls
  accepts_nested_attributes_for :supports
  accepts_nested_attributes_for :groups
  accepts_nested_attributes_for :profile_attributes
  validates_presence_of :name, :title, :sha256
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
      json.attributes(profile_attributes.collect { |profile_attribute| profile_attribute.to_jbuilder.attributes! })
      json.extract! self, :sha256
    end
  end

  def as_json
    to_jbuilder.attributes!
  end

  def to_json
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

  def self.find_or_new(profile_hash)
    # profiles = Profile.where(sha256: profile_hash['sha256'])
    profiles = []
    if profiles.empty?
      new_profile_hash, controls = Profile.transform(profile_hash.deep_dup)
      profile = Profile.create(new_profile_hash)
      controls.each do |control|
        profile.controls.create(control)
      end
      # else
      #  profile = profiles.first
    end
    profile
  end

  def self.parse(profiles)
    all_profiles = []
    results = []
    profiles.try(:each) do |profile_hash|
      profile = Profile.find_or_new profile_hash
      profile_hash['controls'].try(:each) do |control_hash|
        if (control = profile.controls.where(control_id: control_hash['control_id']).try(:first))
          control_hash['results'].try(:each) do |result|
            control.results.create(result)
          end
          results.concat control.results
        end
      end
      all_profiles << profile
    end
    [all_profiles, results]
  end

  def self.transform(hash)
    hash = hash.deep_transform_keys { |key| key.to_s.tr('-', '_').gsub(/\battributes\b/, 'profile_attributes').gsub(/\bid\b/, 'control_id') }
    controls = Control.transform hash.delete('controls')
    hash['profile_attributes'].try(:each) do |attr|
      options = attr.delete('options')
      next unless options
      options.each do |key, value|
        if key == 'default'
          unless value.is_a?(Array)
            unless value.is_a?(String)
              value = value.to_s
            end
            value = [value]
          end
        end
        attr["option_#{key}"] = value
      end
    end
    groups = hash.delete('groups')
    new_groups = []
    groups.each do |group|
      if group['title'].present? and group['controls'].size > 1
        new_groups << group
      end
    end
    hash['groups'] = new_groups if !new_groups.empty?
    [hash, controls]
  end
end
