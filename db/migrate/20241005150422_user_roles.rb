class UserRoles < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :admin, :boolean
    add_column :users, :role, :integer, default: 0
  end
end
