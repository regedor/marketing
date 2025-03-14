# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  description     :text
#  organization_id :bigint           not null
#  sent            :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :text
#
# Indexes
#
#  index_notifications_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
