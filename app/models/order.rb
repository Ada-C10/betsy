class Order < ApplicationRecord
  STATUSES = %w(pending paid complete cancelled)
  has_many :orderitems
  belongs_to :guest
  has_many :products, through: :orderitems

  validates :status, presence: true, inclusion: { in: STATUSES }

end
