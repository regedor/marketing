class Stage < ApplicationRecord
  belongs_to :pipeline
  validates :name, presence: true
  validates :index, presence: true
end
