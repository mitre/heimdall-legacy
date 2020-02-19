class CopyEvaluationToDepends < ActiveRecord::Migration[5.2]
  def up
    Depend.all.each do |dep|
      eval = dep.profile.evaluations.first
      if eval.present?
        dep.evaluation_id = eval.id
        dep.save
      end
    end
  end

  def down
    # do nothing
  end
end
