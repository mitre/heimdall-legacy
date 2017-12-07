class Profile
  include Mongoid::Document
  include Mongoid::Timestamps
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
  has_many :evaluations
  embeds_many :groups, cascade_callbacks: true
  embeds_many :profile_attributes, cascade_callbacks: true
  accepts_nested_attributes_for :controls
  accepts_nested_attributes_for :supports
  accepts_nested_attributes_for :groups
  accepts_nested_attributes_for :profile_attributes
  #has_and_belongs_to_many :evaluations

  @@categories = {"cat i": {low: 0.7, high: 0.9}, "cat ii": {low: 0.4, high: 0.6}, "cat iii": {low: 0.1, high: 0.3},}

  def category cat
    if cat
      @@categories[cat.downcase.to_sym]
    else
      nil
    end
  end

  def nist_hash cat
    nist = {}
    range = self.category cat
    #logger.debug "CAT: #{cat}, range: #{range.inspect}"
    self.controls.each do |control|
      #logger.debug "#{control.control_id}: #{control.impact}"
      if range.nil? || (control.impact <= range[:high] && control.impact >= range[:low])
        if severity = control.tags.where(:name => 'severity').first
          #logger.debug "#{control.control_id}: severity: #{severity}"
          control.tags.where(:name => 'nist').each do |tag|
            if tag.value.is_a? Array
              tag.value.each do |value|
                unless value.include?("Rev")
                  nist[value] = [] unless nist[value]
                  nist[value] << {"name": "#{control.control_id}", "severity": "#{severity.value}", "impact": control.impact, "value": 1}
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
    #logger.debug("NEW HASH: #{hash.inspect}")
    return hash, controls
  end

end
