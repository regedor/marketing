# == Schema Information
#
# Table name: perspectives
#
#  id                :bigint           not null, primary key
#  copy              :text
#  post_id           :bigint           not null
#  socialplatform_id :bigint
#  status            :string           default("in_analysis")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_perspectives_on_post_id            (post_id)
#  index_perspectives_on_socialplatform_id  (socialplatform_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (socialplatform_id => socialplatforms.id)
#
require "test_helper"

class PerspectiveTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
