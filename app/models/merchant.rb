class Merchant < ApplicationRecord
  has_many :products

  has_many :order_items, through: :products





  def self.build_from_github(merchant_hash)

    merchant = Merchant.new

    merchant.uid = merchant_hash[:uid]

    merchant.provider = 'github'

    merchant.name = merchant_hash['info']['name']

    merchant.email = merchant_hash['info']['email']

    # Note that the merchant has not been saved

    return merchant

  end



end
