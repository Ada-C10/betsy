module ProductsHelper
  def readable_cost(cost)
    ("<span class='cost'>" + "#{number_to_currency(cost)}" + "</span>").html_safe
  end

  def readable_name(name)
    ("<span class='name'>" + "#{name.split.map(&:capitalize).join(' ')}" + "</span>").html_safe
  end
end
