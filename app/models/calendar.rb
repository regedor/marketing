class Calendar < ApplicationRecord
  belongs_to :organization
  has_many :posts, dependent: :destroy

  validates :name, presence: true
end
