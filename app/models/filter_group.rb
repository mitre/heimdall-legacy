class FilterGroup < ApplicationRecord
  has_and_belongs_to_many :filters
  validates_presence_of :name
end
