class RemoveUserOldReferences < ActiveRecord::Migration[7.2]
  def change
    remove_reference :personnotes, :user, index: true, foreign_key: true
    remove_reference :people, :user, index: true, foreign_key: true
    remove_reference :posts, :user, index: true, foreign_key: true
    remove_reference :attachmentcounters, :user, index: true, foreign_key: true
    remove_reference :comments, :user, index: true, foreign_key: true
    remove_reference :companynotes, :user, index: true, foreign_key: true
    remove_reference :leadnotes, :user, index: true, foreign_key: true

    change_column_null :personnotes, :member_id, false
    change_column_null :people, :member_id, false
    change_column_null :posts, :member_id, false
    change_column_null :attachmentcounters, :member_id, false
    change_column_null :comments, :member_id, false
    change_column_null :companynotes, :member_id, false
    change_column_null :leadnotes, :member_id, false
  end
end
