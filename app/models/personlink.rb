# == Schema Information
#
# Table name: personlinks
#
#  name       :string           not null, primary key
#  link       :string
#  person_id  :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_personlinks_on_person_id  (person_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#
class Personlink < ApplicationRecord
  belongs_to :person
end
