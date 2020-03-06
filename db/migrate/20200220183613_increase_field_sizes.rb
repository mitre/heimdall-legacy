class IncreaseFieldSizes < ActiveRecord::Migration[5.2]
  def change
    change_column :results, :code_desc, :text
    change_column :controls, :desc, :text
    change_column :controls, :title, :text
  end
end
