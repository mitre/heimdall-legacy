class CreateFilters < ActiveRecord::Migration[5.2]
  def change
    create_table :filters do |t|
      t.string :family
      t.string :number
      t.string :sub_fam
      t.string :sub_num
      t.string :enhancement
      t.string :sub_enh_fam
      t.string :sub_enh_num
      t.references :filter_group, foreign_key: true
      t.integer :created_by_id

      t.timestamps
    end
  end
end
