class Merchant < ApplicationRecord
  has_many :products
  has_many :order_items, through: :products

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true


  def self.build_from_github(merchant_hash)

    merchant = Merchant.new

    merchant.uid = merchant_hash[:uid]

    merchant.provider = 'github'

    merchant.name = merchant_hash['info']['name']

    merchant.email = merchant_hash['info']['email']

    # Note that the merchant has not been saved

    return merchant

  end




  #will try and use this method instead of doing all the work that is now taking place in the show.html.erb
  # def logged_merchant
  #   if @logged_in_merchant
  #     if @logged_in_merchant.id != nil &&  @logged_in_merchant.id ==  @merchant.id
  #       return true
  #     end
  #     return false
  #   end
  #   return false
  # end


  #TODO total revenue by status completed

#TODO filter order displayed by status 


end
