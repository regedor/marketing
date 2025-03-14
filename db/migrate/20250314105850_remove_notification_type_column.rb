class RemoveNotificationTypeColumn < ActiveRecord::Migration[7.2]
  def change
    remove_column :notifications, :type_notification, :integer
  end
end
