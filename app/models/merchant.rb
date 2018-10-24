class Merchant < ApplicationRecord
  STATUSES = %w(pending paid complete cancelled)

  has_many :products
  has_many :orderitems, through: :products

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.build_from_github(auth_hash)
   merchant = Merchant.new
   merchant.uid = auth_hash[:uid]
   merchant.provider = 'github'
   merchant.name = auth_hash['info']['name']
   merchant.email = auth_hash['info']['email']
   return merchant
  end

  def readable_name
    return self.name.split.map(&:capitalize).join(' ')
  end

  def total_revenue
    return self.orderitems.reduce(0) {|sum, item| sum + item.line_item_price}
  end



  def orders_by_status(status)
    orderitems = self.orderitems.select  {|oi| oi.order.status == status}
    orders = orderitems.map { |oi| oi.order }.uniq!
    return orders
  end

  def sales_by_status
    sales = Hash.new

    STATUSES.each do |status|
      orderitems_by_status = self.orderitems.select  {|oi| oi.order.status == status}
      revenue_by_status = orderitems_by_status.reduce(0) {|sum, item| sum + item.line_item_price}
      sales[status] = revenue_by_status
    end
    return sales
  end
end
