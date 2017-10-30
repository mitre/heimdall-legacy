class Depend
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :path, type: String
  embedded_in :profile, :inverse_of => :depends
end
