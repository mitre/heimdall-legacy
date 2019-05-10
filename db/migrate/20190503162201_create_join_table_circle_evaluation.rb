class CreateJoinTableCircleEvaluation < ActiveRecord::Migration[5.2]
  def change
    create_join_table :circles, :evaluations do |t|
      t.index [:circle_id, :evaluation_id]
      t.index [:evaluation_id, :circle_id]
    end
  end
end
