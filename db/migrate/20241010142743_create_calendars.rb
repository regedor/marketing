class CreateCalendars < ActiveRecord::Migration[7.2]
  def change
    create_table :calendars do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
