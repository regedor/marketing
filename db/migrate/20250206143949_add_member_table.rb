class AddMemberTable < ActiveRecord::Migration[7.2]
  def change
    create_table :members do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.boolean :isLeader, default: false, null: false

      t.string :email
      t.string :first_name
      t.string :last_name

      t.timestamps
    end

    add_reference :users, :member, null: true, foreign_key: true

    add_reference :personnotes, :member, foreign_key: true
    add_reference :people, :member, foreign_key: true
    add_reference :posts, :member, foreign_key: true
    add_reference :attachmentcounters, :member, foreign_key: true
    add_reference :comments, :member, foreign_key: true
    add_reference :companynotes, :member, foreign_key: true
    add_reference :leadnotes, :member, foreign_key: true

    User.find_each do |user|
      next unless user.organization_id

      member = Member.create!(
        user_id: user.id, organization_id: user.organization_id, isLeader: user.isLeader, email: user.email
      )

      user.personnotes.update_all(member_id: member.id)
      user.people.update_all(member_id: member.id)
      user.posts.update_all(member_id: member.id)
      user.update(member_id: member.id)
      Attachmentcounter.where(user_id: user.id).update_all(member_id: member.id)
      Comment.where(user_id: user.id).update_all(member_id: member.id)
      Companynote.where(user_id: user.id).update_all(member_id: member.id)
      Leadnote.where(user_id: user.id).update_all(member_id: member.id)
    end
  end
end
