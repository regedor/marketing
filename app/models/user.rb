# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  organization_id        :integer
#  isLeader               :boolean          default(FALSE), not null
#  member_id              :bigint
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_member_id             (member_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (member_id => members.id)
#
class User < ApplicationRecord
  devise :database_authenticatable, :recoverable,
    :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2]

  belongs_to :organization, optional: true
  belongs_to :member, optional: true
  has_many :members,
    class_name: "Member",
    foreign_key: :user_id,
    dependent: :destroy,
    inverse_of: :user

  validates :organization, :email, presence: true

  def self.recent(limit)
    order(created_at: :desc).limit(limit)
  end

  def self.ransackable_attributes(_auth_object = true)
    %w[id email isLeader organization_id created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[id email isLeader organization_id created_at updated_at]
  end
end
