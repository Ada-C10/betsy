class Merchant < ApplicationRecord
  has_many :products

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
