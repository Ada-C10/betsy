class Order < ApplicationRecord
  STATUSES = %w(pending paid complete cancelled)
  has_many :orderitems
  has_many :products, through: :orderitems

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :cc_num, presence: true
  validates :cvv, presence: true
  validates :exp_date, presence: true
  validates :zip, presence: true
end
