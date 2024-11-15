class Company < ApplicationRecord
  belongs_to :organization
  has_many :companynotes, dependent: :destroy
  has_many :personcompanies, dependent: :destroy
  has_many :companylinks, dependent: :destroy
  has_many :leads, dependent: :destroy
  validates :name, presence: true
end
