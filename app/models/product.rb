class Product < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :categories

  has_many :reviews
  has_many :order_products

  validates :name, presence: true


  validates :user_id, presence: true
  validates :stock, presence: true, numericality: { :only_integer => true, :greater_than_or_equal_to => 0}

  validates :price, presence: true, numericality: {:greater_than_or_equal_to => 0}


 def self.active_products
   return Product.all.select {|e| e.status == true}
 end


  def self.category_list(id)
    selected_category = Category.find_by(id:id)
    return self.active_products.select {|prod| prod.categories.include? selected_category}
  end

  def self.merchant_list(id)
    self.active_products.select {|prod| prod.user.id == id}
  end

  def update_stock(quantity_ordered)
    if self.available?(quantity_ordered)
      self.stock -= quantity_ordered
      return self.save
    else
      return false
    end
  end

  def available?(quantity_ordered)
    return false unless (quantity_ordered >= 1 && (quantity_ordered.is_a? Integer))

    if quantity_ordered <= self.stock
      return true
    else
      return false
    end
  end
end
