class CreateEmails < ActiveRecord::Migration[7.2]
  def change
    create_table :emails do |t|
      t.string :email
      t.boolean :current
      t.boolean :is_active
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
