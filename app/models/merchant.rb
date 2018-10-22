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

  def orders_by_status(status)
    orderitems = self.orderitems.select  {|oi| oi.order.status == status}
    orders = orderitems.map { |oi| oi.order }.uniq!
    return orders
  end

  def total_revenue
    return self.orderitems.reduce(0) {|sum, item| sum + item.line_item_price}
  end

  def sales_by_status
    # SJL: This isn't as efficient as it could be, probably could
    # do this all in SQL. Someday...
    sales = orderitems.group_by do |oi|
      oi.order.status
    end

    sales.each do |status, items|
      sales[status] = items.sum { |i| i.line_item_price }
    end

    return sales
  end
end
