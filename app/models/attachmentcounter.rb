# == Schema Information
#
# Table name: attachmentcounters
#
#  id            :bigint           not null, primary key
#  attachment_id :bigint           not null
#  aproved       :boolean          default(FALSE)
#  rejected      :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  member_id     :bigint           not null
#
# Indexes
#
#  index_attachmentcounters_on_attachment_id  (attachment_id)
#  index_attachmentcounters_on_member_id      (member_id)
#
# Foreign Keys
#
#  fk_rails_...  (attachment_id => attachments.id)
#  fk_rails_...  (member_id => members.id)
#
class Attachmentcounter < ApplicationRecord
  belongs_to :attachment
  belongs_to :member
end
