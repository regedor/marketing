# == Schema Information
#
# Table name: socialplatforms
#
#  id         :bigint           not null, primary key
#  name       :string
#  link       :string
#  link_form  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Socialplatform < ApplicationRecord
  has_many :publishplatforms, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    [ "name", "link", "link_form", "created_at", "updated_at" ]
  end
end
