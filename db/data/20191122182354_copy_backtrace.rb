class CopyBacktrace < ActiveRecord::Migration[5.2]
  def up
    Result.all.each.each do |result|
      result.backtrace = result.backtrace_array
      result.save
    end
  end

  def down
    Result.all.each.each do |result|
      result.backtrace = []
      result.save
    end
  end
end
