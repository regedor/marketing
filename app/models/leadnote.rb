class Leadnote < ApplicationRecord
  belongs_to :lead
  belongs_to :user

  validates :note, presence: true
end
