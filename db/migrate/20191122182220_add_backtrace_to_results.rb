class AddBacktraceToResults < ActiveRecord::Migration[5.2]
  def change
    add_column :results, :backtrace, :string, array: true, default: []
  end
end
