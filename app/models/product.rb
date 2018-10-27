class Product < ApplicationRecord
  belongs_to :merchant
  has_and_belongs_to_many :categories
  has_many :order_items, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than: 0, less_than: 1000000 }
  validates_numericality_of :inventory, :only_integer => true, :greater_than_or_equal_to => 0
  validates :is_active, inclusion: { in: [ true, false ] }



  def currency
    self.price *= 1.00
    return self.price.round(2)
  end

  def change_inventory(quantity_ordered)
    new_inventory = self.inventory - quantity_ordered
    self.inventory = new_inventory
    self.save
  end

  # def change_status
  #   if self.is_active == true
  #     self.update(is_active: false)
  #   else
  #     self.update(is_active: true)
  #   end
  #
  #   if self.update(product_params)
  #   end
  # end
end
