module MerchantsHelper
  def render_date(date)
    date.strftime("%b %e, %Y")
  end
end
