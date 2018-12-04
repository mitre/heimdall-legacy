class Description
  include Mongoid::Document
  field :label, type: String
  field :data, type: String
end
