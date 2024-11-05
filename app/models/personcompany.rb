class Personcompany < ApplicationRecord
  belongs_to :person
  belongs_to :company
end
