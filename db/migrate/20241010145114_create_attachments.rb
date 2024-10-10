class CreateAttachments < ActiveRecord::Migration[7.2]
  def change
    create_table :attachments do |t|
      t.references :perspective, null: false, foreign_key: true
      t.string :filename
      t.binary :content
      t.string :status

      t.timestamps
    end
  end
end
