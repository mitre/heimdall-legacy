class AddEvaluationToWaiverData < ActiveRecord::Migration[5.2]
  def up
    WaiverDatum.all.each do |wd|
      wd.evaluation_id = wd.control.results.last.evaluation.id
      wd.save
    end
  end

  def down
  end
end
