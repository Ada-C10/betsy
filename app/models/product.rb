class Product < ApplicationRecord
  has_and_belongs_to_many :categories # do we need dependent: :destroy here?
  belongs_to :user
  has_many :orders_items
  has_many :orders, through: :orders_items

  # Merchant can only have unique products
  validates :name, presence: true

  validates_uniqueness_of :name, :scope => [:user_id]
  # message: "user already has a product with that name" }
  validates :price, presence: true, numericality: {greater_than: 0}

  validates :description, presence: true
  validates :photo, presence: true
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }



  def self.category_list
    categories = []
    Product.all.each do |product|
      product.categories.each do |category|
        categories << category
      end
    end
    return categories.uniq
  end

  def reduce_stock(quantity)
    self.stock = self.stock - quantity
  end

  def can_purchase?(quantity)
    stock >= quantity
  end

end
