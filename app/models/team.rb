class Team < ApplicationRecord
  belongs_to :organization
  validates :name, presence: true, uniqueness: { scope: :organization_id }
  has_many :teams_users, dependent: :destroy
  has_many :users, through: :teams_users
end
