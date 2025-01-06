# == Schema Information
#
# Table name: calendars
#
#  id              :bigint           not null, primary key
#  organization_id :bigint           not null
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_calendars_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Calendar < ApplicationRecord
  belongs_to :organization
  has_many :posts, dependent: :destroy

  validates :name, presence: true
end
