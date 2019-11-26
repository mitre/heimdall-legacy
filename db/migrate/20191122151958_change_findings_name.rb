class ChangeFindingsName < ActiveRecord::Migration[5.2]
  def change
    rename_column :evaluations, :findings, :findings_hash
  end
end
