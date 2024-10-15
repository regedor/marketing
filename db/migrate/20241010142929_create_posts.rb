class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :design_idea
      t.string :categories, array: true, default: []
      t.references :user, null: false, foreign_key: true
      t.references :calendar, null: false, foreign_key: true
      t.string :status, default: "in_analysis"
      t.datetime :publish_date

      t.timestamps
    end
  end
end
