class CreateSupports < ActiveRecord::Migration[5.2]
  def change
    create_table :supports do |t|
      t.string :os_family
      t.string :name
      t.string :value
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
