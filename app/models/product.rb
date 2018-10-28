class Product < ApplicationRecord
  belongs_to :user
  has_many :reviews
  has_many :orderproducts
  has_and_belongs_to_many :categories
  validates :name, :price, presence: true
  validates :name, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates_format_of :photo_url, :with => /\A[http]/


  def self.adjust_stock_count(product_id, count_sold)
    product = Product.find(product_id)
    reduced_stock = product.stock_count - count_sold
    product.update(stock_count: reduced_stock)
    product.save
  end

  def average_rating
    rating = 0
    sum = self.reviews.reduce(0) do |sum, review|
      sum += review.rating
    end
    rating = sum / self.reviews.length if self.reviews.length > 0
    return rating
  end

  def in_cart?(session)
    session.each do |item|
      item.each do |key, value|
        return true if key.to_i == self.id
      end
    end
    return false
  end

  def cart_adjust_quantity(session)
    session.each do |item|
      item.each do |id, quantity|
        return self.stock_count - quantity if id.to_i == self.id
      end
    end
  end

end
