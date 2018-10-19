class Order < ApplicationRecord
  STATUSES = %w(pending paid complete cancelled)
  has_many :orderitems
  has_many :products, through: :orderitems

  validates :status, presence: true, inclusion: { in: STATUSES }

end
