class ChangeWaiverDataName < ActiveRecord::Migration[5.2]
  def change
    rename_column :controls, :waiver_data, :waiver_data_hash
  end
end
