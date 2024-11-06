class CreateCompanynotes < ActiveRecord::Migration[7.2]
  def change
    create_table :companynotes do |t|
      t.text :note
      t.references :user, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
