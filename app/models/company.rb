# == Schema Information
#
# Table name: companies
#
#  id              :bigint           not null, primary key
#  name            :string
#  employers_min   :integer          default(0)
#  employers_max   :integer          default(0)
#  phone_number    :string
#  url_site        :string
#  linkedin_link   :string
#  description     :text
#  organization_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_companies_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Company < ApplicationRecord
  belongs_to :organization
  has_many :companynotes, dependent: :destroy
  has_many :personcompanies, dependent: :destroy
  has_many :companylinks, dependent: :destroy
  has_many :leads, dependent: :destroy
  validates :name, presence: true
end
