module MerchantsHelper
  def readable_name
    return self.name.split.map(&:capitalize).join(' ')
  end

  def last_four
  end
end
