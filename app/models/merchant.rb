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

  def items_by_status(status)
    items = self.orderitems.group_by { |oi| oi.order.status }
    if status = "all"
      return items
    else
      return items[status]
    end
  end

  def self.items_by_orderid(items)
    items = items.group_by {|oi| oi.order.id}
    return items
  end

  def total_revenue
    return self.orderitems.sum { |oi| oi.line_item_price }
  end

  def sales_by_status
    # SJL: This isn't as efficient as it could be, probably could
    # do this all in SQL. Someday...

    sales = self.items_by_status("all")
    sales.each do |status, items|
      sales[status] = items.sum { |item| item.line_item_price }
    end

    return sales
  end
end
