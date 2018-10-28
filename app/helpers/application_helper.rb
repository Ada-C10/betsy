module ApplicationHelper

  def readable_date(date)
    ("<span class='date'>" + date.strftime("%b %d, %Y") + "</span>").html_safe
  end

  def money_display(money)
    ("<span class='money'>$" + '%.2f' % money + "</span>").html_safe
  end


end
