 class Order < ApplicationRecord
  has_many :orders_items, dependent: :destroy
  #if you destroy the order items associated with it
  has_many :products, through: :orders_items, dependent: :destroy
  validates_inclusion_of :status, :in => ["pending", "paid","complete", "cancelled"], presence: :true

  belongs_to :user, optional: true

  #validation so that a user cannot have any products that have their user_id

  # validates :status, presence: true, inclusion: { in: %w(pending complete paid cancelled)}
  # validates :street, presence: true
  # validates :city, presence: true
  # validates :state, presence: true, inclusion: { in: %w(AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY)}
  # validates :zip, presence: true, length: {is: 5}, numericality: { only_integer: true }
  # validates :creditcard, presence: true, length: {is: 4},numericality: { only_integer: true }
  # validates :cvv, presence: true, length: {is: 3},numericality: { only_integer: true }
  # validates :billingzip, presence: true, length: {is: 5},numericality: { only_integer: true }


  # {
  #   orders_item: {
  #     product_id: 1,
  #     quantity: 20
  #   }
  # }
  def add_product(product_id, quantity)
    #Find out if the current product is in the cart
    current_item = OrdersItem.find_by(product_id: product_id, order_id: self.id)

    #If current_product is in the cart then
    if current_item
      #the current_product is an instance of OrdersItem which has quantity attribute
      #increase the quantity then update it
      current_item.quantity += quantity
      current_item.save
    else
      #create a new instance of OrderItems with product params
      #this is what OrderItems was doing - if you have an orderitem you
      #want to add it to the order
      #when you update cart will create order item
      current_item = OrdersItem.create(product_id: product_id,
                                          quantity: quantity,
                                          order_id: self.id)
    end

    return current_item
  end


  def order_calculate_total
     total_cost = 0
     self.orders_items.each do |item|
       total_cost += item.calculate_total
     end
     return total_cost
   end

  def items_in_cart
    # TODO: Update to return accurate quanity of all items in cart
    return self.orders_items.count
  end



end
