class Tag
  include Mongoid::Document
  field :name, type: String
  field :value
  embedded_in :control, inverse_of: :tags
  validates_presence_of :name

  def good_values
    if value.is_a? Array
      good_values = []
      value.each do |value|
        next if value.include?('Rev')
        val = value.scan(/([A-Z]{2,}-\d+)/)
        next if val.empty?
        val = val.first.first
        good_values << val
      end
      good_values
    else
      []
    end
  end
end
