class Order < ApplicationRecord
  STATUSES = %w(pending paid complete cancelled)
  has_many :orderitems
  has_many :products, through: :orderitems

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :name, presence: true, on: :update
  validates :email, presence: true, on: :update
  validates :address, presence: true, on: :update
  validates :cc_num, presence: true, on: :update
  validates :cvv, presence: true, on: :update
  validates :exp_date, presence: true, on: :update
  validates :zip, presence: true, on: :update
end
