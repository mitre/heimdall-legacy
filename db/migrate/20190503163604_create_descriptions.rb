class CreateDescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :descriptions do |t|
      t.string :label
      t.string :data
      t.references :control, foreign_key: true

      t.timestamps
    end
  end
end
