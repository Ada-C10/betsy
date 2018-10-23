module ApplicationHelper
  def readable_date(date)
    ("<span class='date'>" + date.strftime("%A, %b %d") + "</span>").html_safe
  end

  def update_products(order)
    order.order_items.each do |item|
      product = item.product
      product.update_attribute(:inventory, product.inventory -= item.quantity)
    end
  end

end
