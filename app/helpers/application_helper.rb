module ApplicationHelper


  def format_price(amt)
    ("<span class='price'>" + ("$%.2f" % amt) + "</span>").html_safe
  end
end
