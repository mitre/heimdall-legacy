class AddFieldsToDepends < ActiveRecord::Migration[5.2]
  def change
    add_column :depends, :skip_message, :string
    add_column :depends, :compliance, :string
    add_column :depends, :supermarket, :string
  end
end
