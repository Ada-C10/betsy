class Review < ApplicationRecord
  RATINGS = [*1..5]
  belongs_to :product

  validates :name, presence: true
  validates :rating, presence: true, inclusion: { in: RATINGS }
end
