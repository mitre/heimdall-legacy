class CreateDepends < ActiveRecord::Migration[5.2]
  def change
    create_table :depends do |t|
      t.string :name
      t.string :path
      t.string :url
      t.string :status
      t.string :git
      t.string :branch
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
