# == Schema Information
#
# Table name: emails
#
#  id         :bigint           not null, primary key
#  email      :string
#  current    :boolean
#  is_active  :boolean
#  person_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_emails_on_person_id  (person_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#
class Email < ApplicationRecord
  belongs_to :person

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
