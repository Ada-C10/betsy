class User < ApplicationRecord
  has_many :products 
  has_many :orders
  has_many :order_products, through: :products

  validates :cc_num, numericality: { only_integer: true }, allow_nil: true

  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = 'github'
    user.name = auth_hash['info']['name']
    user.email = auth_hash['info']['email']

    # Note that the user has not been saved
    return user
  end

  def is_a_merchant?
     return self.type == "Merchant"
  end

  def total_revenue
    return order_products.map { |op| op.valid? ? op.subtotal : 0 }.sum
  end

  def total_revenue_by_status(op_status)
    return order_products.map { |op| (op.valid? && op.status == op_status) ? op.subtotal : 0 }.sum
  end

  def orders_by_status(op_status)
    return order_products.where(status: op_status)
  end

  def num_orders_by_status(op_status)
    return orders_by_status(op_status).count
  end

   #when a the type "Merchant" is added to a User instance, it will actually become an instance of Merchant rather than a User instance with type Merchant
   def become_merchant
     self.becomes!(Merchant) if self.type_must_be_merchant
     self.save!
   end

   #helper method
   def type_must_be_merchant #custom validation to assure that only type merchant can be subclass Merchant
     self.is_a_merchant? ? true : errors.add(:type, "the user's type must be set to Merchant")
   end
end
