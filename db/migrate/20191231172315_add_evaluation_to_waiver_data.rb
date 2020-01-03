class AddEvaluationToWaiverData < ActiveRecord::Migration[5.2]
  def change
    add_reference :waiver_data, :evaluation, foreign_key: true
  end
end
