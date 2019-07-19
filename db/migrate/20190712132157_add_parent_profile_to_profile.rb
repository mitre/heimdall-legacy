class AddParentProfileToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :parent_profile, :string
  end
end
