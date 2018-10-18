require "test_helper"

describe Merchant do
  let(:merchant) { Merchant.new }

  it "must be valid" do
    value(merchant).must_be :valid?
  end
end

describe "validations" do
  it "requires a name" do
    merchant = Merchant.new
    merchant.valid?.must_equal false
    merchant.errors.messages.must_include :name
  end

  it "requires a unique name" do
      name = "test name"
      merchant1 = Merchant.new(name: name)

      # This must go through, so we use create!
      merchant1.save!

      merchant2 = Merchant.new(name: name)
      result = merchant2.save
      result.must_equal false
      merchant2.errors.messages.must_include :name
    end

  it "requires a email" do
    dan = merchant(:dan)
    dan.email.valid?.must_equal true

  end

  it "requires a unique email" do
    email = "test email"
    user1 = Merchant.new(email: sally@yahoo.com)


    # This must go through, so we use create!
    user1.save!

    user2 = Merchant.new(email: sally@yahoo.com)
    result = merchant2.save
    result.must_equal false
    merchant2.errors.messages.must_include :email
  end
end


# fred:
#   name: Fred
#   email: fred@gmail.com
#   avatar_url: https://via.placeholder.com/200x200

# validates :name, presence: true, uniqueness: true
# validates :email, presence: true, uniqueness: true
