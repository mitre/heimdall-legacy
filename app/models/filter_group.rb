class FilterGroup
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Userstamps::Model
  field :name, type: String
  has_and_belongs_to_many :filters
  validates_presence_of :name
end
