class Companynote < ApplicationRecord
  belongs_to :user
  belongs_to :company

  validates :note, presence: true
end
