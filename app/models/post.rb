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
#  status       :string           default("draft")
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
  belongs_to :user,
    foreign_key: :user_id,
    inverse_of: :posts
  belongs_to :calendar,
    foreign_key: :calendar_id,
    inverse_of: :posts

  has_many :publishplatforms,
    foreign_key: :post_id,
    inverse_of: :post,
    dependent: :destroy
  has_many :comments,
    foreign_key: :post_id,
    inverse_of: :post,
    dependent: :destroy
  has_many :perspectives,
    foreign_key: :post_id,
    inverse_of: :post,
    dependent: :destroy

  accepts_nested_attributes_for :comments,      allow_destroy: true
  accepts_nested_attributes_for :perspectives,  allow_destroy: true

  validates :status,       inclusion: { in: %w[draft pending_review approved rejected archived] }
  validates :publish_date, presence: true
  validates :calendar,     presence: true

  before_save :set_default_title

  private

  def set_default_title
    return unless title.blank? && publish_date.present?

    self.title = publish_date.strftime("%H:%M")
  end
end
