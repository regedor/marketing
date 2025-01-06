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
require "test_helper"

class LeadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
