# == Schema Information
#
# Table name: leads
#
#  id          :bigint           not null, primary key
#  name        :string
#  start_date  :date
#  end_date    :date
#  pipeline_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :bigint
#  person_id   :bigint
#  stage_id    :bigint           not null
#  description :text
#
# Indexes
#
#  index_leads_on_company_id   (company_id)
#  index_leads_on_person_id    (person_id)
#  index_leads_on_pipeline_id  (pipeline_id)
#  index_leads_on_stage_id     (stage_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (pipeline_id => pipelines.id)
#  fk_rails_...  (stage_id => stages.id)
#
class Lead < ApplicationRecord
  belongs_to :pipeline
  belongs_to :company, optional: true
  belongs_to :person, optional: true
  belongs_to :stage

  has_many :leadnotes, dependent: :destroy
  has_many :leadcontents, dependent: :destroy

  validates :name, presence: true
  validates :start_date, presence: true

  after_initialize :set_default_end_date, if: :new_record?
  before_validation :set_default_name, if: -> { name.blank? && pipeline.present? }

  private

  def set_default_end_date
    self.end_date ||= start_date
  end

  def set_default_name
    self.name = pipeline.name if name.blank?
  end
end
