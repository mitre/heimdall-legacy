class CreateAspects < ActiveRecord::Migration[5.2]
  def change
    create_table :aspects do |t|
      t.string :name
      t.text :options
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
