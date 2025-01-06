# == Schema Information
#
# Table name: leadnotes
#
#  id         :bigint           not null, primary key
#  note       :text
#  lead_id    :bigint           not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_leadnotes_on_lead_id  (lead_id)
#  index_leadnotes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (lead_id => leads.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class LeadnoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
