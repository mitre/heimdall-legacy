class AddImpactToControl < ActiveRecord::Migration[5.2]
  def change
    add_column :controls, :impact, :float
  end
end
