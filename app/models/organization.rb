# == Schema Information
#
# Table name: organizations
#
#  id                    :bigint           not null, primary key
#  name                  :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  slack_workspace_token :string
#  slack_channel         :string
#
class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :calendars, dependent: :destroy
  validates :name, presence: true
  has_many :people, dependent: :destroy
  has_many :companies, dependent: :destroy

  def self.recent(limit)
      order(created_at: :desc).limit(limit)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[ id name slack_channel slack_workspace_token created_at updated_at ]
  end
end
