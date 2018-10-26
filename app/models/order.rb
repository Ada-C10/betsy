class Order < ApplicationRecord
  STATUS = %w(pending paid complete cancelled)
  has_many :order_items, dependent: :destroy

  validates :status,  presence: true,
  inclusion: { in: STATUS }

  validates :name, presence: true, if: :is_not_pending
  validates :email, presence: true, if: :is_not_pending
  validates :address, presence: true, if: :is_not_pending
  validates :cc_num, presence: true, if: :is_not_pending
  validates :cc_cvv, presence: true, if: :is_not_pending
  validates :cc_expiration, presence: true, if: :is_not_pending

  def is_not_pending
    return self.status != 'pending'
  end

  def total
    return self.order_items.sum { |item| item.price}
  end

  def CC_num_last_four

    if self.cc_num
      cc_str = self.cc_num.to_s

      if cc_str.length < 4
        return cc_str
      else
        return cc_str.to_s[-4..-1]
      end
    end
  end

  def total_quantity
    return self.order_items.sum {|item| item.quantity }
  end

  def set_paid
    self.update(status: 'paid')

    self.order_items.each do |item|
      item.update(status: 'paid')
    end
  end


  def self.search(search)
    where("id = ?", "#{search}")
  end

end
