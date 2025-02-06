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
  has_many :members,
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

  before_validation :slug_presence

  def self.recent(limit)
      order(created_at: :desc).limit(limit)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[ id name slack_channel slack_workspace_token created_at updated_at ]
  end

  private

  def slug_presence
    return unless slug.blank?

    self.slug = name.parameterize
  end
end
