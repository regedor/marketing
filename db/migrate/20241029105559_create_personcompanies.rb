class CreatePersoncompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :personcompanies, id: false do |t|
      t.boolean :is_working
      t.boolean :is_my_contact
      t.references :person, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
    execute "ALTER TABLE personcompanies ADD PRIMARY KEY (person_id, company_id);"
  end
end
