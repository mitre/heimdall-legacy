class IncreaseResultMessageSize < ActiveRecord::Migration[5.2]
  def change
    change_column :results, :message, :text
  end
end
