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
#  slug                  :string           not null
#
# Indexes
#
#  index_organizations_on_slug  (slug) UNIQUE
#
class Organization < ApplicationRecord
  has_many :users,
    dependent: :destroy,
    foreign_key: :organization_id
  has_many :calendars,
    dependent: :destroy,
    foreign_key: :organization_id
  has_many :people,
    dependent: :destroy,
    foreign_key: :organization_id
  has_many :companies,
    dependent: :destroy,
    foreign_key: :organization_id

  validates :name, :slug, presence: true

  before_save :refresh_valid_slack_bot_token!, if: :slack_workspace_token_changed?

  def self.recent(limit)
      order(created_at: :desc).limit(limit)
  end

  def refresh_valid_slack_bot_token!
    return false if slack_workspace_token.blank?

    valid_response = Slack::Web::Client.new(token: slack_workspace_token).auth_test&.dig("ok")
    valid_response
  rescue StandardError
    self.slack_workspace_token = nil
    nil
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[ id name slack_channel slack_workspace_token created_at updated_at ]
  end
end
