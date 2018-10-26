class Merchant < ApplicationRecord
  has_many :products
  has_many :order_items, through: :products

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  def self.create_from_github(auth_hash)
    merchant = Merchant.new
    merchant.username = auth_hash['info']['nickname']
    merchant.email = auth_hash['info']['email']
    merchant.uid = auth_hash['uid']
    merchant.provider = 'github'

    return merchant
  end

  def all_order_items_subtotal
    return self.order_items.sum { |item| item.price }
  end

  def paid_order_items
    return self.order_items.where(status: 'paid')
  end

  def paid_orders_subtotal
    return self.paid_order_items.sum { |item| item.price }
  end

  def complete_order_items
    return self.order_items.where(status: 'complete')
  end

  def completed_orders_subtotal
    return self.complete_order_items.sum { |item| item.price }
  end

  def rating


    products_with_reviews = self.products.find_all{ |product| product.rating }

    if products_with_reviews.empty?
      return nil
    else
      return 1.0 * products_with_reviews.sum{ |product| product.rating } / products_with_reviews.length
    end

  end
end
