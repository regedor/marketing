class Pipeattribute < ApplicationRecord
  belongs_to :pipeline
  has_many :leadcontents, dependent: :destroy
  validates :name, presence: true
end
