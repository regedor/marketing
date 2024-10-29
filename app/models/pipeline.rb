class Pipeline < ApplicationRecord
  belongs_to :organization
  has_many :leads, dependent: :destroy

  validates :name, presence: true
end
