# == Schema Information
#
# Table name: pipelines
#
#  id              :bigint           not null, primary key
#  name            :string
#  to_people       :boolean
#  organization_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_pipelines_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Pipeline < ApplicationRecord
  belongs_to :organization
  has_many :leads, dependent: :destroy
  has_many :pipeattributes, dependent: :destroy
  has_many :stages, dependent: :destroy

  validates :name, presence: true
end
