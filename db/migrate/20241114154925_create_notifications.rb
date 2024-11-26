class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.text :description
      t.references :organization, null: false, foreign_key: true
      t.integer :type_notification
      t.boolean :sent, default: false

      t.timestamps
    end
  end
end
