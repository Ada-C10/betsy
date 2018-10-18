class Order < ApplicationRecord
  STATUSES = %w(pending paid complete cancelled)
  has_many :orderitems
  has_and_belongs_to_many :merchants
  belongs_to :guests

  validates :status, presence: true, inclusion: { in: STATUSES }

end
