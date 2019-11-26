class CreateInputs < ActiveRecord::Migration[5.2]
  def change
    create_table :inputs do |t|
      t.string :name
      t.jsonb :options
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
