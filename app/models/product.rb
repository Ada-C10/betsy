class Product < ApplicationRecord
  belongs_to :merchant

  has_many :reviews
  has_many :order_items

  has_and_belongs_to_many :categories

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }


  def rating
    unless self.reviews.empty?
      return 1.0 * self.reviews.sum{ |review| review.rating } / self.reviews.length
    end
    return "No ratings"
  end
end
