class CreatePerspectives < ActiveRecord::Migration[7.2]
  def change
    create_table :perspectives do |t|
      t.text :copy
      t.references :post, null: false, foreign_key: true
      t.references :socialplatform, null: true, foreign_key: true
      t.string :status, default: "in_analysis"

      t.timestamps
    end
  end
end
