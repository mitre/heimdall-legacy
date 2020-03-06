class CreateRefs < ActiveRecord::Migration[5.2]
  def change
    create_table :refs do |t|
      t.string :ref
      t.string :url
      t.string :uri
      t.references :control, foreign_key: true

      t.timestamps
    end
  end
end
