class Review < ApplicationRecord
  belongs_to :product
  validates :rating, numericality: { only_integer: true }
  validates_inclusion_of :rating, numericality: true, in: (1..5)
  validates :description, presence: true
end
