class AddWaiverDataToControl < ActiveRecord::Migration[5.2]
  def change
    add_column :controls, :waiver_data, :text
  end
end
