class CreateControls < ActiveRecord::Migration[5.2]
  def change
    create_table :controls do |t|
      t.string :title
      t.string :desc
      t.string :impact
      t.text :refs
      t.text :code
      t.string :control_id
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
