class User < ApplicationRecord
  # validations
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
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

<<<<<<< HEAD
  def find_orders
    sold = []
    self.products.each do |product|
      if !product.order_items.empty?
        sold << product
      end
    end

    # OrderItem.all.each do |item|
    #  if self.products.include? item.product_id
    #     sold << item
    #   end
    # end
    # binding.pry
    return sold
=======
  def revenue
    @pending = self.orders.where(status: 1)
    @paid = self.orders.where(status: 2)
    @shipped = self.orders.where(status: 3)
    @completed = self.orders.where(status: 4)

>>>>>>> merchant_info
  end


end
