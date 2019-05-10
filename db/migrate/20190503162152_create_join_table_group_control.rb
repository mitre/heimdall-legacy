class CreateJoinTableGroupControl < ActiveRecord::Migration[5.2]
  def change
    create_join_table :groups, :controls do |t|
      t.index [:group_id, :control_id]
      t.index [:control_id, :group_id]
    end
  end
end
