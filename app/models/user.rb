class User < ApplicationRecord
  has_many :items
  # has_many :orders
  has_many :reviews

  validates :nickname, presence: true, uniqueness: {
    scope: :provider, message: "User: username already exists for this provider. Please login or reset password."
  }

  validates :email, presence: true, uniqueness: true

  # def self.build_from_github(auth_hash)
  #   user = User.new(provider: auth_hash['provider'], uid: auth_hash['uid'], nickname: auth_hash['info']['nickname'], name: auth_hash['info']['name'], email: auth_hash['info']['email'], image_url: auto_hash['info']['image'])
  # end

#accepts user_ids from applicationcontroller @merchant_ids
#returns true if this instance of a user has a product/ is a merchant
# @current_user.is_a_merchant?(@merchant_ids)
  def is_a_merchant?(given_ids)
    return given_ids.include?(self.id)
  end
end
