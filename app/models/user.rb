class User < ApplicationRecord
  # validations
  validates :username, presence: true, uniqueness: true
  validates :uid, presence: true, uniqueness: {scope: :provider}
  validates :email, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  # relationships
  has_many :products
  has_many :order_items, through: :products

  def self.new_user(auth_hash)
    new_user = User.new(email: auth_hash[:info][:email],
                        username: auth_hash[:info][:nickname],
                        uid: auth_hash[:uid],
                        provider: 'github')

    return new_user
  end


  def find_ordered_items
    ordered_items = []
    self.products.each do |product|
      unless product.order_items.empty?
        product.order_items.each do |ord_item|
        ordered_items << ord_item
        end
      end
    end
    return ordered_items
  end


  def revenue(status_filter)
    rev = 0
    if status_filter == "Total"
      self.order_items.each do |item|
        rev += item.subtotal
      end
      return rev
    else
      self.order_items.each do |item|
        if item.order.status == status_filter
          rev += item.subtotal
        end
      end
    end

    return rev
  end
end


