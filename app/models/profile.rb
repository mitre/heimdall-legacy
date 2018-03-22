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
  field :sha256, type: String
  embeds_many :depends, cascade_callbacks: true
  embeds_many :supports, cascade_callbacks: true
  has_many :controls
  has_and_belongs_to_many :evaluations
  embeds_many :groups, cascade_callbacks: true
  embeds_many :profile_attributes, cascade_callbacks: true
  accepts_nested_attributes_for :depends
  accepts_nested_attributes_for :controls
  accepts_nested_attributes_for :supports
  accepts_nested_attributes_for :groups
  accepts_nested_attributes_for :profile_attributes
  validates_presence_of :name, :title, :sha256

  def is_editable?
    evaluations.empty?
  end

  def control_families
    families = []
    nist = {}
    controls.each do |control|
      control.tags.where(name: 'nist').each do |tag|
        next unless tag.value.is_a? Array
        tag.value.each do |value|
          next if value.include?('Rev')
          val = value.split('(')[0].strip
          nist[val] = [] unless nist[val]
          nist[val] << control
          families << val
        end
      end
    end
    [families, nist]
  end

  def nist_hash(cat)
    nist = {}
    controls.each do |control|
      severity = control.tags.where(name: 'severity').first
      next unless severity && (cat.nil? || cat == severity.value)
      control.tags.where(name: 'nist').each do |tag|
        next unless tag.value.is_a? Array
        tag.value.each do |value|
          next if value.include?('Rev')
          val = value.split('(')[0].strip
          nist[val] = [] unless nist[val]
          nist[val] << { "name": control.control_id.to_s, "severity": severity.value, "impact": control.impact, "value": 1 }
        end
      end
    end
    nist
  end

  def self.find_or_new(profile_hash)
    profile = Profile.where(sha256: profile_hash['sha256']).try(:first)
    unless profile
      new_profile_hash, controls = Profile.transform(profile_hash.deep_dup)
      profile = Profile.create(new_profile_hash)
      controls.each do |control|
        logger.debug "Add Control: #{control.keys}"
        profile.controls.create(control)
      end
    end
    profile
  end

  def self.parse(profiles)
    all_profiles = []
    results = []
    profiles.try(:each) do |profile_hash|
      profile = Profile.find_or_new profile_hash
      profile_hash['controls'].try(:each) do |control_hash|
        logger.debug "For #{control_hash['control_id']}"
        if (control = profile.controls.where(control_id: control_hash['control_id']).try(:first))
          logger.debug 'Found Control'
          control_hash['results'].try(:each) do |result|
            logger.debug "For result #{result.inspect}"
            control.results.create(result)
          end
          results.concat control.results
        end
        logger.debug "Results: #{results.size}"
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
