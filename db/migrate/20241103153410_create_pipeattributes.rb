class CreatePipeattributes < ActiveRecord::Migration[7.2]
  def change
    create_table :pipeattributes do |t|
      t.string :name
      t.references :pipeline, null: false, foreign_key: true

      t.timestamps
    end
  end
end
