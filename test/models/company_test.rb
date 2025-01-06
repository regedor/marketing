# == Schema Information
#
# Table name: companies
#
#  id              :bigint           not null, primary key
#  name            :string
#  employers_min   :integer          default(0)
#  employers_max   :integer          default(0)
#  phone_number    :string
#  url_site        :string
#  linkedin_link   :string
#  description     :text
#  organization_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_companies_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
