# == Schema Information
#
# Table name: people
#
#  id              :bigint           not null, primary key
#  name            :string
#  birthdate       :date
#  description     :text
#  is_private      :boolean
#  linkedin_link   :string
#  organization_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  member_id       :bigint           not null
#
# Indexes
#
#  index_people_on_member_id        (member_id)
#  index_people_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (member_id => members.id)
#  fk_rails_...  (organization_id => organizations.id)
#
class Person < ApplicationRecord
  belongs_to :member
  belongs_to :organization

  has_many :emails, dependent: :destroy
  has_many :phonenumbers, dependent: :destroy
  has_many :personnotes, dependent: :destroy
  has_many :personlinks, dependent: :destroy
  has_many :personcompanies, dependent: :destroy

  validates :name, presence: true
end
