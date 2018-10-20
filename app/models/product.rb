class Product < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_and_belongs_to_many :categories
  belongs_to :merchant
  has_many :orders, through: :orderitems
  has_many :orderitems, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :cost, presence: true, numericality: { greater_than: 0 }, allow_nil: true
  validates :inventory, presence: true, numericality: { only_integer: true }
  validates :description, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates :image_url, presence: true

  def self.adjust_inventory(order_items)
    order_items.each do |item|
      item.product.inventory -= item.quantity
      if item.product.inventory == 0
        item.product.destroy
      else
        item.product.save
      end
    end
  end
end
