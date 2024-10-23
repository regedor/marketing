class CreatePublishplatforms < ActiveRecord::Migration[7.2]
  def change
    create_table :publishplatforms do |t|
      t.references :socialplatform, null: false, foreign_key: true
      t.references :post,null: false, foreign_key: true

      t.timestamps
    end
  end
end
