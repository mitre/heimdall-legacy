class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :path_id
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
