class AddIsLeaderToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :isLeader, :boolean, default: false, null: false
  end
end
