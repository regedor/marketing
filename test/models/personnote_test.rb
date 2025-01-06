# == Schema Information
#
# Table name: personnotes
#
#  id         :bigint           not null, primary key
#  note       :text
#  person_id  :bigint           not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_personnotes_on_person_id  (person_id)
#  index_personnotes_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class PersonnoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
