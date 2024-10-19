class CreateConsultations < ActiveRecord::Migration[7.2]
  def change
    create_table :consultations do |t|
      t.string :title
      t.text :description
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
