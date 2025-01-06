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
require "test_helper"

class StageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
