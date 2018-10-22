module ApplicationHelper
  def readable_cost(cost)
    ("<span class='cost'>" + "#{number_to_currency(cost)}" + "</span>").html_safe
  end

  def readable_date(date)
    ("<span class='date'>" + "#{date.strftime("%B %d, %Y")} at #{date.strftime("%H:%M %p")}" + "</span>").html_safe
  end
end
