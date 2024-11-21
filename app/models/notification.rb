class Notification < ApplicationRecord
  belongs_to :organization

  validates :description, presence: true
  validates :type_notification, presence: true
end
