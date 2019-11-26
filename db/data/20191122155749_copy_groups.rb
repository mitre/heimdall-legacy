class CopyGroups < ActiveRecord::Migration[5.2]
  def up
    Group.all.each.each do |group|
      group.controls = group.controls_array
      group.save
    end
  end

  def down
    Group.all.each.each do |group|
      group.controls = []
      group.save
    end
  end
end
