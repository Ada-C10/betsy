class Order < ApplicationRecord
  has_many :orderproducts, dependent: :destroy
  validates :cc_number, :cc_cvv, :total_cost, :zip_code, numericality: true, on: :update

  validates :name, :email, :mailing_address, :zip_code, :cc_number,
  :cc_expiration, :cc_cvv, :status, :total_cost, presence: true, on: :update

  validates :orderproducts, :length => { :minimum => 1 }, on: :update

  def order_total
    total_cost = 0
    self.orderproducts.each do |orderproduct|
      total_cost += (orderproduct.product.price * orderproduct.quantity)
    end
    total_cost
  end

  def reduce_stock
    self.orderproducts.each do |item|
      Product.adjust_stock_count(item.product_id, item.quantity)
    end
  end

  def self.find_orderproducts(user, status)
    orderproducts = []
    Order.all.each do |order|
      if order.status == status || status == nil
        order.orderproducts.each do |item|
          product = item.product
          if user.id == product.user_id
            orderproducts << item
          end
        end
      end
    end
    orderproducts
  end

  def self.count_orders(user, status)
    count = 0
    Order.all.each do |order|
      if order.status == status || status == nil
        order.orderproducts.each do |item|
          product = item.product
          if user.id == product.user_id
            count += 1
          end
        end
      end
    end
    count
  end

  def self.products_sold_total(user, orderproducts)
    total_revenue = 0
    orderproducts.each do |item|
        product = item.product
        if user.id == product.user_id
          per_unit_cost = item.product.price
          total_revenue += item.quantity * per_unit_cost
        end
    end
    total_revenue
  end



end
