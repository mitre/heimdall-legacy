class CopyStatistics < ActiveRecord::Migration[5.2]
  def up
    Evaluation.where.not(statistics_hash: nil).each do |eval|
      stats = Statistic.create(duration: eval.statistics_hash['duration'])
      eval.statistic = stats
    end
  end

  def down
    Statistic.all.each do |stats|
      stats.destroy
    end
  end
end
