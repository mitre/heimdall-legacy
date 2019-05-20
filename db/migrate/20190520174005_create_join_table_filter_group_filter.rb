class CreateJoinTableFilterGroupFilter < ActiveRecord::Migration[5.2]
  def change
    create_join_table :filter_groups, :filters do |t|
      # t.index [:filter_group_id, :filter_id]
      # t.index [:filter_id, :filter_group_id]
    end
  end
end
