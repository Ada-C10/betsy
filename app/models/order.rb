class Order < ApplicationRecord
  STATUSES = %w(pending paid complete cancelled)
  has_many :orderitems
  has_and_belongs_to_many :merchants

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :cc_num, presence: true, numericality: { only_integer: true }, length: { is: 16 }
  validates :cvv, presence: true, length: { in: 3..4 }
  validate :expiration_date_cannot_be_in_the_past
  validates :zip, presence: true

  def expiration_date_cannot_be_in_the_past
   if exp_date.present? && exp_date < Date.today
     errors.add(:exp_date, 'can’t be in the past')
   end
  end
end
