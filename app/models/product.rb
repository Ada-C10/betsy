class Product < ApplicationRecord
  has_many :reviews
  has_many :order_items
  # for join table
  has_many :orders, through: :order_items
  belongs_to :merchant
  has_and_belongs_to_many :categories

  validates :name, presence: true, uniqueness: true
  # TODO: maybe product name must be unique to category???
  validates :price, presence: true, numericality: { greater_than: 0 }

  # Deleted/inactive products aren't shown
  default_scope { where(status: true) }

  validates :inventory, presence: true, numericality: { greater_than: -1 }



  # QUESTION: how to handle invalid photo URLS since that will 'show up' ??
  # QUESTION: status default --> true?? to show it's automatically active?


  # QUESTION: should these be view helpers instead?
  def price_int_to_float()
    return convert_int_to_f(self.price)
  end

  def price_float_to_int()
    return self.price * 100
  end


end
