class AddFieldsToSupports < ActiveRecord::Migration[5.2]
  def change
    add_column :supports, :os_name, :string
    add_column :supports, :platform, :string
    add_column :supports, :platform_family, :string
    add_column :supports, :platform_name, :string
    add_column :supports, :release, :string
    add_column :supports, :inspec_version, :string
  end
end
