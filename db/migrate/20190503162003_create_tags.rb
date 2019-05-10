class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.text :content
      t.references :tagger, polymorphic: true, index: true

      t.timestamps
    end
  end
end
