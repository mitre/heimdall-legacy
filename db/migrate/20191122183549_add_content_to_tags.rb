class AddContentToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :content, :jsonb
  end
end
