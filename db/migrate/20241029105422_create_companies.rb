class CreateCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.integer :employers_min, default: 0
      t.integer :employers_max, default: 0
      t.string :phone_number
      t.string :url_site
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
