class Lead < ApplicationRecord
  belongs_to :pipeline
  belongs_to :company, optional: true
  belongs_to :person, optional: true
  belongs_to :stage

  has_many :leadnotes, dependent: :destroy
  has_many :leadcontents, dependent: :destroy

  validates :name, presence: true
  validates :start_date, presence: true

  after_initialize :set_default_end_date, if: :new_record?
  before_validation :set_default_name, if: -> { name.blank? && pipeline.present? }

  private

  def set_default_end_date
    self.end_date ||= start_date
  end

  def set_default_name
    self.name = pipeline.name if name.blank?
  end
end
