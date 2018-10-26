
class User < ApplicationRecord

  has_many :orders, dependent: :destroy
  has_many :products, dependent: :destroy
  validates :email, presence: true, format: { with: /.+@.+\..+\z/ }, uniqueness: true
  validates :name, presence: true

  def self.build_from_github(auth_hash)
   new_user = User.new

   new_user.uid = auth_hash[:uid]
   new_user.provider = 'github'
   new_user.name = auth_hash[:info][:name]
   new_user.email = auth_hash[:info][:email]

   return new_user
  end

  def sold_items
    # sold items array
    # loop through products of merchant
    # loop through orders_items
    # Push each item to array
    # return the array
    # in view, check if array is empty before trying to show things
    @my_sold_items = []
    self.products.each do |product|
      # Checking if product has order items
      product.orders_items.each do |item|
        # Pushing each item into my_sold_items
        @my_sold_items << item
      end
    end
    return @my_sold_items
  end

  # Helper method to return order items for different status types
  def order_items_for_status(status)
    self.sold_items.select { |item| item.order.status == status.downcase }
  end



end
