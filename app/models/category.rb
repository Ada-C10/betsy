class Category < ApplicationRecord
  # validations
  validates :category, presence: true, uniqueness: true

  # relationships

  has_and_belongs_to_many :products

end
