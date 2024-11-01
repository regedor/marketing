class CreatePersonlinks < ActiveRecord::Migration[7.2]
  def change
    create_table :personlinks do |t|
      t.jsonb :content, default: {}
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
