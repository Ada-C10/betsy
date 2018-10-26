module ApplicationHelper
  def readable_cost(cost)
    ("<span class='cost'>" + "#{number_to_currency(cost)}" + "</span>").html_safe
  end

  def readable_date(date)
    ("<span class='date'>" + "#{date.strftime("%B %d, %Y")} at #{date.strftime("%H:%M %p")}" + "</span>").html_safe
  end

  def last_four(order)
    cc = order.cc_num.gsub(/\D/, '')
    last = cc.size - 1
    first = cc.size - 4
    return cc[first..last]
  end

  def shopping_cart_count(count)
    '<i class="fa fa-shopping-cart"><span class="badge badge-danger d-flex justify-content-around">'.html_safe + "#{count}" '</span></i>'.html_safe
  end

  def readable_order(order)
    if order == 1
      return "Order"
    else
      return "Orders"
    end
  end
end
