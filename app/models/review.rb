class Review < ApplicationRecord
  belongs_to :product

    validates :star_rating, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5, only_integer: true }
end
