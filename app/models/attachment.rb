class Attachment < ApplicationRecord
  belongs_to :perpective

  has_many :attachementcounters, dependent: :destroy
  accepts_nested_attributes_for :attachmentcounters, allow_destroy: true
  
  validates :filename, presence: true
  validates :status, inclusion: { in: %w[approved in_analysis rejected] }
end
