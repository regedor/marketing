class Perspective < ApplicationRecord
  belongs_to :post
  belongs_to :socialplatform, optional: true

  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true

  validates :copy, presence: true
  validates :status, inclusion: { in: %w[approved in_analysis rejected] }
end
