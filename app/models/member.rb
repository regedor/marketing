# == Schema Information
#
# Table name: members
#
#  id              :bigint           not null, primary key
#  user_id         :bigint           not null
#  organization_id :bigint           not null
#  isLeader        :boolean          default(FALSE), not null
#  email           :string
#  first_name      :string
#  last_name       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_members_on_organization_id  (organization_id)
#  index_members_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (user_id => users.id)
#
class Member < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  has_many :personnotes, dependent: :destroy
  has_many :people, dependent: :destroy
  has_many :posts,
    class_name: "Post",
    foreign_key: :member_id,
    dependent: :destroy,
    inverse_of: :member
  has_many :comments,
    class_name: "Comment",
    foreign_key: :member_id,
    dependent: :destroy,
    inverse_of: :member

  validates :organization, :user, presence: true

  validate :user_synchronization, on: :update

  private

  def user_synchronization
    user.update(isLeader: isLeader, email: email)
  end
end
