# == Schema Information
#
# Table name: personcompanies
#
#  is_working    :boolean
#  is_my_contact :boolean
#  person_id     :bigint           not null, primary key
#  company_id    :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_personcompanies_on_company_id  (company_id)
#  index_personcompanies_on_person_id   (person_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (person_id => people.id)
#
require "test_helper"

class PersoncompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
