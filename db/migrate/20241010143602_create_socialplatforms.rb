class CreateSocialplatforms < ActiveRecord::Migration[7.2]
  def change
    create_table :socialplatforms do |t|
      t.string :name
      t.string :link
      t.string :link_form

      t.timestamps
    end
  end
end
