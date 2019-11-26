class ChangePlatformName < ActiveRecord::Migration[5.2]
  def change
    rename_column :evaluations, :platform, :platform_hash
  end
end
