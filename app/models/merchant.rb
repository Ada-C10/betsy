class Merchant < ApplicationRecord
  has_many :products

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  # TODO: maybe check for valid email form xxx@xxx.xxx

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = 'github'
    merchant.email = auth_hash['info']['email']
    merchant.username = auth_hash['info']['nickname']
    return merchant
  end
end
