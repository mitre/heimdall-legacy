class CreateFindings < ActiveRecord::Migration[5.2]
  def change
    create_table :findings do |t|
      t.integer :failed
      t.integer :passed
      t.integer :not_reviewed
      t.integer :profile_error
      t.integer :not_applicable
      t.references :evaluation, foreign_key: true

      t.timestamps
    end
  end
end
