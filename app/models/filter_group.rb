class FilterGroup < ApplicationRecord
  resourcify
  has_and_belongs_to_many :filters
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  validates_presence_of :name
end
