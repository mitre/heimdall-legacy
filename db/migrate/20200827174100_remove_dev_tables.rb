class RemoveDevTables < ActiveRecord::Migration[5.2]
  def change
    table_exists?(:api_keys) ? drop_table(:api_keys) : nil
    table_exists?(:auths_user_pass) ? drop_table(:auths_user_pass) : nil
    table_exists?(:reset_tokens) ? drop_table(:reset_tokens) : nil
    table_exists?(:sessions) ? drop_table(:sessions) : nil
    table_exists?(:usergroups) ? drop_table(:usergroups) : nil
    table_exists?(:usergroups_roles) ? drop_table(:usergroups_roles) : nil
    table_exists?(:users_usergroups) ? drop_table(:users_usergroups) : nil
  end
end
