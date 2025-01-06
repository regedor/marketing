# == Schema Information
#
# Table name: phonenumbers
#
#  id         :bigint           not null, primary key
#  number     :string
#  current    :boolean
#  is_active  :boolean
#  person_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_phonenumbers_on_person_id  (person_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#
require "test_helper"

class PhonenumberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
