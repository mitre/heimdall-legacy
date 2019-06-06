class AddEvaluationToResults < ActiveRecord::Migration[5.2]
  def change
    add_reference :results, :evaluation, foreign_key: true
  end
end
