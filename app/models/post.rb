class Post < ApplicationRecord
  belongs_to :user
  belongs_to :calendar
  before_save :set_default_title

  has_many :publishplatforms, dependent: :destroy
  
  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :comments, allow_destroy: true
  
  has_many :perspectives, dependent: :destroy
  accepts_nested_attributes_for :perspectives, allow_destroy: true

  validates :status, inclusion: { in: %w[approved in_analysis rejected] }
  validates :publish_date, presence: true
  validates :calendar, presence: true
  validates :design_idea, presence: true
  private
    def set_default_title
      if title.blank? && publish_date.present?
        self.title = publish_date.to_s
      end
    end
end
