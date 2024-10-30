class CreateLeads < ActiveRecord::Migration[7.2]
  def change
    create_table :leads do |t|
      t.string :name
      t.jsonb :content, default: {}
      t.date :start_date
      t.date :end_date
      t.references :pipeline, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
