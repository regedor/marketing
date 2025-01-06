# == Schema Information
#
# Table name: companynotes
#
#  id         :bigint           not null, primary key
#  note       :text
#  user_id    :bigint           not null
#  company_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_companynotes_on_company_id  (company_id)
#  index_companynotes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (user_id => users.id)
#
class Companynote < ApplicationRecord
  belongs_to :user
  belongs_to :company

  validates :note, presence: true
end
