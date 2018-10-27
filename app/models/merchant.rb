class Merchant < ApplicationRecord
  has_many :products
  has_many :categories
  has_many :order_items, through: :product
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.build_from_github(auth_hash)
    return Merchant.new(provider: auth_hash[:provider], uid: auth_hash[:uid], email: auth_hash[:info][:email], username: auth_hash[:info][:nickname])
  end


  def revenue
    revenue = 0.0
    self.products.each do |product|
      product.order_items.each do |order_item|
        if order_item.status != 'pending'
          revenue += (order_item.product.price * order_item.quantity)
        end
      end
    end

    return revenue.round(2)
  end

end
