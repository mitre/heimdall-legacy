class DependantsParent < ApplicationRecord
  belongs_to :parent, class_name: 'Profile', foreign_key: :parent_id
  belongs_to :dependant, class_name: 'Profile', foreign_key: :dependant_id
end
