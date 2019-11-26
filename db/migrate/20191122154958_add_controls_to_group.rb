class AddControlsToGroup < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :controls, :string, array: true, default: []
  end
end
