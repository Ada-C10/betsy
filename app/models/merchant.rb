class Merchant < User
  validates :type, presence: true
  validate :type_must_be_merchant

  #merchant inherits all things from user, but when a new merchant is created the 'type' is automagically set to merchant.

  #if a merchant type is set to nil, then the Merchant instance will become an instance of the superclass
  def become_user(merchant)
    merchant.becomes!(User) if !merchant.valid_merchant
  end

  #create method to be sure it is not nil, then add to validation
  #merchant needs ability to fulfill orders as 'shipped'
end
