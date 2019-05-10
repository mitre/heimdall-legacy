class CreateJoinTableEvaluationProfile < ActiveRecord::Migration[5.2]
  def change
    create_join_table :evaluations, :profiles do |t|
      # t.index [:evaluation_id, :profile_id]
      # t.index [:profile_id, :evaluation_id]
    end
  end
end
