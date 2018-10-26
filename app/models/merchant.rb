class Merchant < ApplicationRecord
  has_many :products
  has_many :order_items, through: :products

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true


  def self.build_from_github(merchant_hash)
    merchant = Merchant.new
    merchant.uid = merchant_hash[:uid]
    merchant.provider = 'github'
    merchant.name = merchant_hash['info']['name']
    merchant.email = merchant_hash['info']['email']
    # Note that the merchant has not been saved
    return merchant
  end

  def order_total
    total = 0
    self.order_items.each do |order_item|
      if order_item.order.status == "paid"
        total += order_item.item_total
      end
    end
    return total
  end


  def tax
    return (order_total * 0.1)
  end


  def total_tax
    return (order_total + tax)
  end
end
