class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates :cc_num, presence: true, length: { is: 16, message: "Credit Card number must be 16 digits" }, on: :update
  validates :name, presence: true, on: :update
  validates :email, presence: true, on: :update
  validates :address, presence: true, on: :update
  validates :zip, presence: true, length: { is: 5 }, on: :update
  validates :cvv, presence: true, on: :update
  validate :cant_be_expired, on: :update


  TAX_RATE = 0.101

  def subtotal
    return self.order_items.sum { |o_items| o_items.item_total }
  end

  def self.tax_rate
    return (TAX_RATE * 100).round(2)
  end

  def total
    return self.subtotal * (1 + TAX_RATE)
  end

  def self.months
    return [*1..12]
  end

  def self.years
    current_year = get_current_year
    return [*current_year..( current_year + 30 )]
  end

  def self.get_current_month
    current_month = Date.current.month
  end

  def self.get_current_year
    current_year = Date.current.year
  end

  def cant_be_expired
    if exp_year < Order.get_current_year
      errors.add(:exp_year, "Credit Card expired in #{exp_year}")
    elsif exp_year == Order.get_current_year && exp_month < Order.get_current_month
      errors.add(:exp_month, "Credit Card is expired")
    end
  end


end
