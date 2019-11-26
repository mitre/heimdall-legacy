class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :controls, :impact, :impact_string
  end
end
