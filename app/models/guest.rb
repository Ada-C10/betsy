class Guest < ApplicationRecord
  has_many :orders
 #all moved over from the order model
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
