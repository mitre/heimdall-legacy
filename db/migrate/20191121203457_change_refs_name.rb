class ChangeRefsName < ActiveRecord::Migration[5.2]
  def change
    rename_column :controls, :refs, :refs_array
  end
end
