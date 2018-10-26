class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  belongs_to :merchant
  has_many :order_items
  has_many :reviews

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: {greater_than: 0}

  def average_rating
    return self.reviews.average(:rating)
  end

  def already_in_cart(cart)
    status = cart.nil? ? nil : cart.order_items.find_by(product_id: self.id)

    return status ? status.id : status

  end

  def self.search(search)
    return Product.where("name iLIKE ?", "%#{search}%")
  end


end
