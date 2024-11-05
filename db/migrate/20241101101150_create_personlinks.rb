class CreatePersonlinks < ActiveRecord::Migration[7.2]
  def change
    create_table :personlinks, id: false do |t|
      t.string :name
      t.string :link
      t.references :person, null: false, foreign_key: true
      t.timestamps
    end
    execute "ALTER TABLE personlinks ADD PRIMARY KEY (person_id, name);"
  end
end
