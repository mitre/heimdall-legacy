class AddEvaluationToDepends < ActiveRecord::Migration[5.2]
  def change
    add_reference :depends, :evaluation, foreign_key: true
  end
end
