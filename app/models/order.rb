class Order < ApplicationRecord
  has_many :order_items

  valid_status = %w(cart paid complete)

  validates :status, presence: true
  validates :email, presence: true, unless: :is_cart?
  validates :mailing_address, presence: true, unless: :is_cart?
  validates :cc, presence: true, unless: :is_cart?
  validates :cc_name, presence: true, unless: :is_cart?
  validates :cc_expiration, presence: true, unless: :is_cart?
  validates :cvv, presence: true, unless: :is_cart?
  validates :zip, presence: true, unless: :is_cart?

  def is_cart?
    return self.status == 'cart'
  end
end
