# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  post_id    :bigint           not null
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  member_id  :bigint           not null
#
# Indexes
#
#  index_comments_on_member_id  (member_id)
#  index_comments_on_post_id    (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (member_id => members.id)
#  fk_rails_...  (post_id => posts.id)
#
class Comment < ApplicationRecord
  belongs_to :member
  belongs_to :post

  validates :content, presence: true
end
