class Socialplatform < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    [ "name", "link", "link_form", "created_at", "updated_at" ]
  end
end
