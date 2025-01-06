# == Schema Information
#
# Table name: organizations
#
#  id                    :bigint           not null, primary key
#  name                  :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  slack_workspace_token :string
#  slack_channel         :string
#
require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
