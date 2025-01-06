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
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  belongs_to :organization, optional: true

  has_many :personnotes, dependent: :destroy
  has_many :people, dependent: :destroy

  def self.recent(limit)
    order(created_at: :desc).limit(limit)
  end

  def self.ransackable_attributes(auth_object = true)
    %w[id email isLeader organization_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[id email isLeader organization_id created_at updated_at]
  end
end
