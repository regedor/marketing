# == Schema Information
#
# Table name: leadcontents
#
#  id               :bigint           not null, primary key
#  value            :string
#  lead_id          :bigint           not null
#  pipeattribute_id :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_leadcontents_on_lead_id           (lead_id)
#  index_leadcontents_on_pipeattribute_id  (pipeattribute_id)
#
# Foreign Keys
#
#  fk_rails_...  (lead_id => leads.id)
#  fk_rails_...  (pipeattribute_id => pipeattributes.id)
#
class Leadcontent < ApplicationRecord
  belongs_to :lead
  belongs_to :pipeattribute

  validates :value, exclusion: { in: [ nil ], message: "Can't be Null" }
end
