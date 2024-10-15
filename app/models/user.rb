class User < ApplicationRecord
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable

  belongs_to :organization, optional: true




  def self.recent(limit)
    order(created_at: :desc).limit(limit)
  end

  def self.ransackable_attributes(auth_object = true)
    %w[id email isLeader organization_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[id email isLeader organization_id created_at updated_at]
  end
end
