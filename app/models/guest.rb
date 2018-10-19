class Guest < ApplicationRecord
  has_one :order

  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :cc_num, presence: true
  validates :cvv, presence: true, length: { in: 3..4 }
  validate :exp_date, presence: true
  validates :zip, presence: true
end
