class Lead < ApplicationRecord
  belongs_to :pipeline
  belongs_to :company

  has_many :leadnotes, dependent: :destroy
  validates :name, presence: true
  validates :start_date, presence: true

  after_initialize :set_default_end_date, if: :new_record?

  private

  def set_default_end_date
    self.end_date ||= start_date
  end
end
