class Merchant < ApplicationRecord
  has_many :products
  has_and_belongs_to_many :orders

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
