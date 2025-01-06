# == Schema Information
#
# Table name: publishplatforms
#
#  socialplatform_id :bigint           not null, primary key
#  post_id           :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_publishplatforms_on_post_id            (post_id)
#  index_publishplatforms_on_socialplatform_id  (socialplatform_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (socialplatform_id => socialplatforms.id)
#
class Publishplatform < ApplicationRecord
  belongs_to :post
  belongs_to :socialplatform
end
