class Review < ApplicationRecord
  belongs_to :product

  validates :rating,  presence: true, numericality: { only_integer: true }
  validates_inclusion_of :rating, :in => [ 1, 2, 3, 4, 5 ]
  validates :name,  presence: true
  validates :review,  presence: true
  validates :product_id,  presence: true

end
