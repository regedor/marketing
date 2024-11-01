class CreatePeople < ActiveRecord::Migration[7.2]
  def change
    create_table :people do |t|
      t.string :name
      t.date :birthday
      t.text :descripcion
      t.boolean :is_private
      t.string :linkedin_link
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
