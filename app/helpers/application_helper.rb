module ApplicationHelper
  def readable_date(date)
    ("<span class='date'>" + date.strftime("%A, %b %d") + "</span>").html_safe
  end

  def find_image_for(product)
    if product.img_file.blank?
      return "/assets/default-c38c428026912f52392d06885f157a9d82d8d3e02918b5cb2dcf67eec1cee594.jpg"
    else
      return product.img_file
    end
  end

  def update_products(order)
    order.order_items.each do |item|
      product = item.product
      product.update_attribute(:inventory, product.inventory -= item.quantity)
    end
  end






  


end
