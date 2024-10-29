class CreatePersonnotes < ActiveRecord::Migration[7.2]
  def change
    create_table :personnotes do |t|
      t.text :note
      t.references :person, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
