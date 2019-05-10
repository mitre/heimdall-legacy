class CreateJoinTableCircleProfile < ActiveRecord::Migration[5.2]
  def change
    create_join_table :circles, :profiles do |t|
      t.index [:circle_id, :profile_id]
      t.index [:profile_id, :circle_id]
    end
  end
end
