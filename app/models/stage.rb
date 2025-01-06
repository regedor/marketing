# == Schema Information
#
# Table name: stages
#
#  id          :bigint           not null, primary key
#  name        :string
#  is_final    :boolean          default(FALSE)
#  index       :integer
#  pipeline_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_stages_on_pipeline_id  (pipeline_id)
#
# Foreign Keys
#
#  fk_rails_...  (pipeline_id => pipelines.id)
#
class Stage < ApplicationRecord
  belongs_to :pipeline
  validates :name, presence: true
  validates :index, presence: true

  # TODO: rever isto. é suposto quando se apagar um stage apagar os TODOS leads associados?
  has_many :leads, dependent: :destroy
end
