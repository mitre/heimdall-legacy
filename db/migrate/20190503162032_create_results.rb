class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.string :status
      t.string :code_desc
      t.string :skip_message
      t.string :resource
      t.float :run_time
      t.date :start_time
      t.string :message
      t.string :exception
      t.text :backtrace
      t.references :control, foreign_key: true

      t.timestamps
    end
  end
end
