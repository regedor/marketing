class User < ApplicationRecord
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable

  after_create :assign_super_admin
  belongs_to :organization, optional: true

  private

  def assign_super_admin
    if email == ENV['SUPER_ADMIN_EMAIL']
      update(admin: true)
    end
  end
  
end
