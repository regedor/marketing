class CreateStages < ActiveRecord::Migration[7.2]
  def change
    create_table :stages do |t|
      t.string :name
      t.boolean :is_final, default: false
      t.integer :index
      t.references :pipeline, null: false, foreign_key: true

      t.timestamps
    end
  end
end
