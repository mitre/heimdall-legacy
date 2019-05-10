class CreateEvaluations < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluations do |t|
      t.string :version
      t.string :other_checks
      t.text :platform
      t.text :statistics
      t.datetime :start_time
      t.text :findings
      t.references :profile, foreign_key: true
      t.integer :created_by_id

      t.timestamps
    end
  end
end
