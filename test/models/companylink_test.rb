# == Schema Information
#
# Table name: companylinks
#
#  name       :string           not null, primary key
#  link       :string
#  company_id :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_companylinks_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
require "test_helper"

class CompanylinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
