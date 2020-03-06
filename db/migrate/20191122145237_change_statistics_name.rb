class ChangeStatisticsName < ActiveRecord::Migration[5.2]
  def change
    rename_column :evaluations, :statistics, :statistics_hash
  end
end
