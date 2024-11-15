class Stage < ApplicationRecord
  belongs_to :pipeline
  validates :name, presence: true
  validates :index, presence: true
  
  # TODO: rever isto. é suposto quando se apagar um stage apagar os TODOS leads associados?
  has_many :leads, dependent: :destroy 
end
