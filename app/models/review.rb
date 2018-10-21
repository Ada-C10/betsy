class Review < ApplicationRecord
  belongs_to :product

  validates :rating, presence: true, numericality: {only_integer: true, greater_than: 0, less_than_or_equal_to: 5}
  validates :description, presence: true
end
