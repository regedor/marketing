class User < ApplicationRecord
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable

  after_create :assign_super_admin
  belongs_to :organization, optional: true
  has_many :teams_users, dependent: :destroy
  has_many :teams, through: :teams_users

  enum role: { User: 0, Leader: 1, Admin: 2 }

  private

  def assign_super_admin
    if email == ENV["SUPER_ADMIN_EMAIL"]
      update(role: 2)
    end
  end
end
