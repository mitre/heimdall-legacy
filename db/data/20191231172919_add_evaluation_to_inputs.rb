class AddEvaluationToInputs < ActiveRecord::Migration[5.2]
  def up
    Input.all.each do |inp|
      eval = inp.profile.evaluations.first
      if eval.present?
        inp.evaluation_id = eval.id
        inp.save
      end
    end
  end

  def down
  end
end
