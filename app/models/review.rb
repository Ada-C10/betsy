class Review < ApplicationRecord
  belongs_to :item
  belongs_to :user
  #
  # validates :rating, presence: true

end
