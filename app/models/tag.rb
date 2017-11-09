class Tag
  include Mongoid::Document
  field :name, type: String
  field :value
  embedded_in :control, :inverse_of => :tags
end
