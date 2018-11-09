class Order < ApplicationRecord
  # belongs_to :user
  has_many :order_items

  VALID_MONTHS = (01..12).to_a

  attr_reader :valid_years

  validate :validate_years, on: :update

  validates_inclusion_of :credit_card_exp_month, :in => VALID_MONTHS, message: "Please enter a valid month.", on: :update

  validates :credit_card_exp_year, :in => @valid_years, on: :update

  validates :order_items, length: { minimum: 1 }, on: :update

  def submit_order
    if !self.order_items.empty?
      self.status = "paid"
      self.order_items.each do |order_item|
        order_item.submit_order_item
      end
    end
  end

  private

  def self.valid_years
    two_digit_date = Date.today.year % 1000
    @valid_years = (two_digit_date .. two_digit_date + 8).to_a
    return @valid_years
  end

  def validate_years
    valid_years = Order.valid_years
    errors.add("Credit cared exp year", "is invalid.") unless valid_years.include?(self.credit_card_exp_year)
  end
end
