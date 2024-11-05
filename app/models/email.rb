class Email < ApplicationRecord
  belongs_to :person

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
