class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :title
      t.string :control_id
      t.text :controls
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
