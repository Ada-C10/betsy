class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, uniqueness: true, presence: true

  # def self.product_photo
  #   photos = []
  #   Product.all.each do |product|
  #     photos << product.photo
  #   end
  #   return photos.sample
  # end

  def product_photo
    photos = []
    self.products.each do |product|
      photos << product.photo
    end
    return photos.sample
  end



end
