class DropParentProfileFromProfile < ActiveRecord::Migration[5.2]
  def change
    if column_exists? :profiles, :parent_profile
      remove_column :profiles, :parent_profile
    end
  end
end
