class Order < ApplicationRecord
  has_many :order_items

  validates :cc_num, presence: true, length: { is: 16, message: "Credit Card number must be 16 digits" }, on: :update
  validates :name, presence: true, on: :update
  validates :email, presence: true, on: :update
  validates :address, presence: true, on: :update
  validates :zip, presence: true, length: { is: 5 }, on: :update
  validates :cvv, presence: true, on: :update
  validates :exp_date, presence: true, on: :update


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


end
