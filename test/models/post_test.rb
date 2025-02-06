# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  title        :string
#  design_idea  :text
#  categories   :string           default([]), is an Array
#  calendar_id  :bigint           not null
#  status       :string           default("draft")
#  publish_date :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  member_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_calendar_id  (calendar_id)
#  index_posts_on_member_id    (member_id)
#
# Foreign Keys
#
#  fk_rails_...  (calendar_id => calendars.id)
#  fk_rails_...  (member_id => members.id)
#
require "test_helper"

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
