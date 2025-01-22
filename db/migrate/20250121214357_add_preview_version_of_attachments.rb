class AddPreviewVersionOfAttachments < ActiveRecord::Migration[7.2]
  def change
    add_reference :attachments, :attachment, null: true, foreign_key: true
  end
end
