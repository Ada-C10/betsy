class Item < ApplicationRecord
  belongs_to :user
  has_many :reviews
  belongs_to :category
  has_many :order_items

  VALID_CATEGORIES = ["accessories", "books", "clothing", "seasonal", "luggage", "shoes", "tech", "miscellaneous"]

  validates :name, presence: true, uniqueness: {
    scope: [:user, :category], message: "User: has already added this item in this category. Please change item inventory."
  }

  validates :price, presence: true
  validates :quantity_available,   presence: true


  def decrement_quantity_available(num)
    if num
      self.quantity_available -= num
      self.save
    end
  end


  # guest login is set to 0
  # def is_authenticated_user?
  #   session[:user_id] != 0 ? true: false
  #   return
  # end

  # user created the product
  # def user_created_product?
  #   if session[:user_id] == @self.user_id ? user_created = true: false
  #     return user_created
  #   end
  # end



  def return_quantity_selection

    iterations = self.quantity_available

    quantity_options = []

    iterations.times do |number|
      quantity_options << number + 1
    end

    return quantity_options
  end


  def item_subtotal(price,qty)
    item_subtotal = price * qty

    return item_subtotal
  end


end
