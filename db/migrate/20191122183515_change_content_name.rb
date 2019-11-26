class ChangeContentName < ActiveRecord::Migration[5.2]
  def change
    rename_column :tags, :content, :content_hash
  end
end
