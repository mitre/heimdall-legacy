class ChangeGroupName < ActiveRecord::Migration[5.2]
  def change
    rename_column :groups, :controls, :controls_array
  end
end
