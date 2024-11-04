class Attachment < ApplicationRecord
  belongs_to :perspective

  has_many :attachmentcounters, dependent: :destroy

  validates :filename, presence: true
  validates :status, inclusion: { in: %w[approved in_analysis rejected] }
end
