class Pipeline < ApplicationRecord
  belongs_to :organization
  has_many :leads, dependent: :destroy
  has_many :pipeattributes, dependent: :destroy
  has_many :stages, dependent: :destroy

  validates :name, presence: true
end
