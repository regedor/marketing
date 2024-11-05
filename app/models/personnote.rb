class Personnote < ApplicationRecord
  belongs_to :person
  belongs_to :user
  validates :note, presence: true
end
