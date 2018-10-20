module ApplicationHelper
  def readable_cost(cost)
    ("<span class='cost'>" + "#{number_to_currency(cost)}" + "</span>").html_safe
  end
end
