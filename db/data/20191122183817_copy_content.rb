class CopyContent < ActiveRecord::Migration[5.2]
  def up
    Tag.all.each do |tag|
      tag.content = tag.content_hash
      tag.save
    end
  end

  def down
    Tag.all.each do |tag|
      tag.content = nil
      tag.save
    end
  end
end
