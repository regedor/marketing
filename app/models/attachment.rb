class Attachment < ApplicationRecord
  belongs_to :perpective

  has_many :attachementcounters, dependent: :destroy

  validates :filename, presence: true
  validates :status, inclusion: { in: %w[approved in_analysis rejected] }
end
