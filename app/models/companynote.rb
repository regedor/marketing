# == Schema Information
#
# Table name: companynotes
#
#  id         :bigint           not null, primary key
#  note       :text
#  company_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  member_id  :bigint           not null
#
# Indexes
#
#  index_companynotes_on_company_id  (company_id)
#  index_companynotes_on_member_id   (member_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (member_id => members.id)
#
class Companynote < ApplicationRecord
  belongs_to :member
  belongs_to :company

  validates :note, presence: true
end
