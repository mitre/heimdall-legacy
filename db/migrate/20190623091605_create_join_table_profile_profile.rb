class CreateJoinTableProfileProfile < ActiveRecord::Migration[5.2]
  def change
    create_join_table(:parents, :dependants) do |t|
    end
  end
end
