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
class Personnote < ApplicationRecord
  belongs_to :person
  belongs_to :user
  validates :note, presence: true
end
