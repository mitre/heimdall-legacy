class AddEvaluationToInputs < ActiveRecord::Migration[5.2]
  def up
    Input.all.each do |inp|
      inp.evaluation_id = inp.profile.evaluations.first.id
      inp.save
    end
  end

  def down
  end
end
