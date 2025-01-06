# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  title        :string
#  design_idea  :text
#  categories   :string           default([]), is an Array
#  user_id      :bigint           not null
#  calendar_id  :bigint           not null
#  status       :string           default("in_analysis")
#  publish_date :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_posts_on_calendar_id  (calendar_id)
#  index_posts_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (calendar_id => calendars.id)
#  fk_rails_...  (user_id => users.id)
#
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
        self.title = publish_date.strftime("%H:%M")
      end
    end
end
