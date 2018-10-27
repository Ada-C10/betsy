class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates_associated :products
  
  validates :name, presence: true, uniqueness: true
end
