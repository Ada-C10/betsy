class Category < ApplicationRecord
  has_and_belongs_to_many :products
  validates :name, presence: true, uniqueness: true

  def self.category_list
   return Category.all.map do |category|
     [category.id, category.name]
   end
 end
end
