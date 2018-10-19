class Guest < ApplicationRecord
  has_many :orders

  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :cc_num, presence: true
  validates :cvv, presence: true, length: { in: 3..4 }
  validates :exp_date, presence: true
  validates :zip, presence: true
end
