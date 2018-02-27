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
  accepts_nested_attributes_for :controls
  accepts_nested_attributes_for :supports
  accepts_nested_attributes_for :groups
  accepts_nested_attributes_for :profile_attributes

  def is_editable?
    evaluations.size == 0
  end

  def control_families
    families = []
    nist = {}
    self.controls.each do |control|
      control.tags.where(:name => 'nist').each do |tag|
        if tag.value.is_a? Array
          tag.value.each do |value|
            unless value.include?("Rev")
              vals = value.split(" ")
              nist[vals[0]] = [] unless nist[vals[0]]
              nist[vals[0]] << control
              families << vals[0]
            end
          end
        end
      end
    end
    return families, nist
  end

  def by_nist_family
    nist = {}
    self.controls.each do |control|
      control.tags.where(:name => 'nist').each do |tag|
        if tag.value.is_a? Array
          tag.value.each do |value|
            unless value.include?("Rev")
              vals = value.split(" ")
              nist[vals[0]] = [] unless nist[vals[0]]
              nist[vals[0]] << control
            end
          end
        end
      end
    end
    nist.sort.to_h
  end

  def nist_hash cat
    nist = {}
    #logger.debug "CAT: #{cat}, range: #{range.inspect}"
    self.controls.each do |control|
      #logger.debug "#{control.control_id}: #{control.impact}"
      if severity = control.tags.where(:name => 'severity').first
        if cat.nil? || cat == severity.value
          #logger.debug "#{control.control_id}: severity: #{severity}"
          control.tags.where(:name => 'nist').each do |tag|
            if tag.value.is_a? Array
              tag.value.each do |value|
                unless value.include?("Rev")
                  vals = value.split(" ")
                  nist[vals[0]] = [] unless nist[vals[0]]
                  nist[vals[0]] << {"name": "#{control.control_id}", "severity": "#{severity.value}", "impact": control.impact, "value": 1}
                end
              end
            end
          end
        end
      end
    end
    nist
  end

  def self.transform hash
    hash = hash.deep_transform_keys{ |key| key.to_s.tr('-', '_').gsub(/\battributes\b/, 'profile_attributes').gsub(/\bid\b/, 'control_id') }
    hash["controls"].try(:each) do |control|
      tags = control.delete('tags')
      results = control.delete('results')
      new_tags = []
      #logger.debug("TAGS: #{tags.inspect}")
      tags.each do |key, value|
        new_tags << {"name": "#{key}", "value": value}
      end
      unless tags.key? "severity"
        new_tags << {"name": "severity", "value": Control.severity(control['impact'])}
      end
      #logger.debug("new tags: #{new_tags.inspect}")
      control["tags"] = new_tags
      source_location = control.delete('source_location')
      source_location.try(:each) do |key, value|
        control["sl_#{key}"] = value
      end
    end
    controls = hash.delete('controls')
    hash['profile_attributes'].try(:each) do |attr|
      options = attr.delete('options')
      options.each do |key, value|
        if key == "default"
          unless value.kind_of?(Array)
            unless value.kind_of?(String)
              value = "#{value}"
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
      if group["title"].present? and group["controls"].size > 1
        new_groups << group
      end
    end
    hash["groups"] = new_groups if new_groups.size > 0
    #logger.debug("NEW HASH: #{hash.inspect}")
    return hash, controls
  end

end
