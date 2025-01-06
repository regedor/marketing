# == Schema Information
#
# Table name: pipeattributes
#
#  id          :bigint           not null, primary key
#  name        :string
#  pipeline_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_pipeattributes_on_pipeline_id  (pipeline_id)
#
# Foreign Keys
#
#  fk_rails_...  (pipeline_id => pipelines.id)
#
class Pipeattribute < ApplicationRecord
  belongs_to :pipeline
  has_many :leadcontents, dependent: :destroy
  validates :name, presence: true
end
