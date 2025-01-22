# == Schema Information
#
# Table name: attachments
#
#  id             :bigint           not null, primary key
#  perspective_id :bigint           not null
#  filename       :string
#  type_content   :string
#  content        :binary
#  status         :string           default("in_analysis")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  attachment_id  :bigint
#
# Indexes
#
#  index_attachments_on_attachment_id   (attachment_id)
#  index_attachments_on_perspective_id  (perspective_id)
#
# Foreign Keys
#
#  fk_rails_...  (attachment_id => attachments.id)
#  fk_rails_...  (perspective_id => perspectives.id)
#
require "test_helper"

class AttachmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
