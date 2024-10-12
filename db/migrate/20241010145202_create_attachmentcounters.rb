class CreateAttachmentcounters < ActiveRecord::Migration[7.2]
  def change
    create_table :attachmentcounters do |t|
      t.references :attachment, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :aproved, default: false
      t.boolean :rejected, default: false

      t.timestamps
    end
  end
end
