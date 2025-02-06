# == Schema Information
#
# Table name: leadnotes
#
#  id         :bigint           not null, primary key
#  note       :text
#  lead_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  member_id  :bigint           not null
#
# Indexes
#
#  index_leadnotes_on_lead_id    (lead_id)
#  index_leadnotes_on_member_id  (member_id)
#
# Foreign Keys
#
#  fk_rails_...  (lead_id => leads.id)
#  fk_rails_...  (member_id => members.id)
#
require "test_helper"

class LeadnoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
