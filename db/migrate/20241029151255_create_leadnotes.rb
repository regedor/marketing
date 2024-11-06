class CreateLeadnotes < ActiveRecord::Migration[7.2]
  def change
    create_table :leadnotes do |t|
      t.text :note
      t.references :lead, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
