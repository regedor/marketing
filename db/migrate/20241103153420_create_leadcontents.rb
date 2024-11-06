class CreateLeadcontents < ActiveRecord::Migration[7.2]
  def change
    create_table :leadcontents do |t|
      t.string :value
      t.references :lead, null: false, foreign_key: true
      t.references :pipeattribute, null: false, foreign_key: true

      t.timestamps
    end
  end
end
