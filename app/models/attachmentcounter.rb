# == Schema Information
#
# Table name: attachmentcounters
#
#  id            :bigint           not null, primary key
#  attachment_id :bigint           not null
#  user_id       :bigint           not null
#  aproved       :boolean          default(FALSE)
#  rejected      :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_attachmentcounters_on_attachment_id  (attachment_id)
#  index_attachmentcounters_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (attachment_id => attachments.id)
#  fk_rails_...  (user_id => users.id)
#
class Attachmentcounter < ApplicationRecord
  belongs_to :attachment
  belongs_to :user
end
