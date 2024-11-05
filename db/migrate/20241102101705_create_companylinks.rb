class CreateCompanylinks < ActiveRecord::Migration[7.2]
  def change
    create_table :companylinks, id: false do |t|
      t.string :name
      t.string :link
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
    execute "ALTER TABLE companylinks ADD PRIMARY KEY (company_id, name);"
  end
end
