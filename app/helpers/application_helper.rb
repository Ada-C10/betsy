module ApplicationHelper
  def format_money(price)
    return sprintf("$%.2f", price)
  end

  def format_date(date)
    return date.strftime("%A, %b %d")
  end
end
