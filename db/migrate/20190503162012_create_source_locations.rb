class CreateSourceLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :source_locations do |t|
      t.string :ref
      t.integer :line
      t.references :control, foreign_key: true

      t.timestamps
    end
  end
end
