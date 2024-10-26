class CreatePublishplatforms < ActiveRecord::Migration[7.2]
  def change
    create_table :publishplatforms, id: false  do |t|
      t.references :socialplatform, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
    execute "ALTER TABLE publishplatforms ADD PRIMARY KEY (socialplatform_id, post_id);"
  end
end
