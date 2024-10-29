class Company < ApplicationRecord
  belongs_to :organization
  has_many :companynotes, dependent: :destroy
  has_many :personcompanies, dependent: :destroy
  validates :name, presence: true
end
