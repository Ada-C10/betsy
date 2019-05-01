class Product < ApplicationRecord
  # validations
  validates :prod_name, presence: true, uniqueness: true
  validates :description, :price, presence: true
  validates :inv_qty, presence: true, numericality: { only_integer: true} # no need to validate inv_qty less than 0 because I am making it inactive
  # relationships
  belongs_to :user
  has_many :reviews
  # has_and_belongs_to_many :orders

  has_and_belongs_to_many :categories
  has_many :order_items

  def self.by_category(id)
    all_products = Product.all.where(active: true)
    category_products = []

    all_products.each do |product|
      if product.categories.find_by(id: id)
        category_products << product
      end
    end
    return category_products
  end

  def self.by_merchant(id)
    all_products = Product.all.where(active: true)
    merchant_products = []

    all_products.each do |product|
      if product.user.id == id
        merchant_products << product
      end
    end
    return merchant_products
  end


  def avg_rating
    reviews = self.reviews
    if reviews.count > 0
      total = reviews.reduce(0) { |sum, review| sum + review.rating }
      avg = total/reviews.count

      return avg
    end
  end
end
