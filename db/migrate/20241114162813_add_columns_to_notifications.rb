class AddColumnsToNotifications < ActiveRecord::Migration[7.2]
  def change
    add_column :notifications, :title, :text
  end
end
