class Tag
  include Mongoid::Document
  field :name, type: String
  field :value
  embedded_in :control, inverse_of: :tags
  validates_presence_of :name
end
