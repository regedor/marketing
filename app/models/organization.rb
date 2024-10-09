class Organization < ApplicationRecord
    has_many :users
    validates :name, presence: true

    def self.recent(limit)
        order(created_at: :desc).limit(limit)
    end
  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "created_at", "updated_at"]
  end
end
