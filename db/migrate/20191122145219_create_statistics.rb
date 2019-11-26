class CreateStatistics < ActiveRecord::Migration[5.2]
  def change
    create_table :statistics do |t|
      t.string :duration
      t.references :evaluation, foreign_key: true

      t.timestamps
    end
  end
end
