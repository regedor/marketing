# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  organization_id        :integer
#  isLeader               :boolean          default(FALSE), not null
#  member_id              :bigint
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_member_id             (member_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (member_id => members.id)
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
