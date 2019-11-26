class CreatePlatforms < ActiveRecord::Migration[5.2]
  def change
    create_table :platforms do |t|
      t.string :name
      t.string :release
      t.references :evaluation, foreign_key: true

      t.timestamps
    end
  end
end
