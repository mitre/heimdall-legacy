class AddEvaluationToWaiverData < ActiveRecord::Migration[5.2]
  def up
    WaiverDatum.all.each do |wd|
      eval = wd.control.results.last.evaluation
      if eval.present?
        wd.evaluation_id = eval.id
        wd.save
      end
    end
  end

  def down
  end
end
