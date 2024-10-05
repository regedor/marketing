class Organization < ApplicationRecord
    has_many :users
    has_many :teams
    validates :name, presence: true
end
