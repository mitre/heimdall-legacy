class CreateWaiverData < ActiveRecord::Migration[5.2]
  def change
    create_table :waiver_data do |t|
      t.string :justification
      t.boolean :run
      t.boolean :skipped_due_to_waiver
      t.string :message
      t.references :control, foreign_key: true

      t.timestamps
    end
  end
end
