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
#
# Indexes
#
#  index_attachments_on_perspective_id  (perspective_id)
#
# Foreign Keys
#
#  fk_rails_...  (perspective_id => perspectives.id)
#
class Attachment < ApplicationRecord
  belongs_to :perspective

  has_many :attachmentcounters, dependent: :destroy

  validates :filename, presence: true
  validates :status, inclusion: { in: %w[approved in_analysis rejected] }
end
