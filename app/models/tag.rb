class Tag < ApplicationRecord
  store :content_hash, accessors: [:name, :value], coder: JSON
  belongs_to :tagger, polymorphic: true

  def good_values
    value = content['value']
    if value.is_a? Array
      good_values = []
      value.each do |value|
        next if value.include?('Rev')

        val = value.scan(/([A-Z]{2,}-\d+)/)
        next if val.empty?

        val = val.first.first
        good_values << val
      end
      good_values.uniq
    else
      []
    end
  end

  def self.options_for_select
    options = []
    Constants::TAG_NAMES.each do |val|
      options << [val, val.downcase]
    end
    options
  end
end
