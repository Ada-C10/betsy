class Category < ApplicationRecord
  has_many :products
  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :products

  def self.category_list
    category_list = []
    Category.all.each do |cat|
      category_list << cat.name
    end
    category_list
  end

end
