class CreatePhonenumbers < ActiveRecord::Migration[7.2]
  def change
    create_table :phonenumbers do |t|
      t.string :number
      t.boolean :current
      t.boolean :is_active
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
