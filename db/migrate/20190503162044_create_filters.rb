class CreateFilters < ActiveRecord::Migration[5.2]
  def change
    create_table :filters do |t|
      t.string :family
      t.string :number
      t.string :sub_fam
      t.string :sub_num
      t.string :enhancement
      t.string :enh_sub_fam
      t.string :enh_sub_num
      t.integer :created_by_id

      t.timestamps
    end
  end
end
