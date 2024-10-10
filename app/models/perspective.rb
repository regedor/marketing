class Perspective < ApplicationRecord
  belongs_to :post
  belongs_to :socialplatform

  has_many :attachments, dependent: :destroy

  validates :copy, presence: true
  validates :status, inclusion: { in: %w[approved in_analysis rejected] }
end
