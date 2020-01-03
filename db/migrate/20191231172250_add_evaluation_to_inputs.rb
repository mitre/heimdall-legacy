class AddEvaluationToInputs < ActiveRecord::Migration[5.2]
  def change
    add_reference :inputs, :evaluation, foreign_key: true
  end
end
