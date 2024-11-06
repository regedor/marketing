class Leadcontent < ApplicationRecord
  belongs_to :lead
  belongs_to :pipeattribute

  validates :value, exclusion: { in: [ nil ], message: "Can't be Null" }
end
