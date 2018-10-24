class Order < ApplicationRecord
  STATUSES = %w(pending paid complete cancelled)
  has_many :orderitems
  # belongs_to :guests
  has_many :products, through: :orderitems


  # SJL: I changed this validation so that merchant#ship would not get validated
  # (merchant#ship only provides a status)
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :name, presence: true, if: :placing_order?
  validates :email, presence: true, if: :placing_order?
  validates :address, presence: true, if: :placing_order?
  validates :cc_num, presence: true, if: :placing_order?
  validates :cvv, presence: true, if: :placing_order?
  validates :exp_date, presence: true, if: :placing_order?
  validates :zip, presence: true, if: :placing_order?

  def placing_order?
    :status == "pending"
  end

  def total_cost
    total_cost = self.orderitems.reduce(0) {|sum, item| sum + item.line_item_price}

    return total_cost
  end
end
