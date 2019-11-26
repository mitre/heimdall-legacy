class ChangeBacktraceName < ActiveRecord::Migration[5.2]
  def change
    rename_column :results, :backtrace, :backtrace_array
  end
end
