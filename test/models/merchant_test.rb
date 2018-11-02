require 'test_helper'

describe Merchant do
  let (:merchant) {merchants(:merchant)}

  it "must be valid" do
    value(merchant).must_be :valid?
  end

  it "must be an instance of Merchant" do
    expect(merchant).must_be_instance_of Merchant
  end

  it "must be kind of User" do
    expect(merchant).must_be_kind_of User
  end

  it "only users with type merchant are instance of merchant" do
    not_merchant = users(:user1)

    expect(not_merchant).must_be_instance_of User
    expect(not_merchant).wont_be_instance_of Merchant
  end

  it "will not create a new merchant if type is nil" do
    not_a_merchant = Merchant.new(
      name: 'Newbie',
      uid: 890,
      provider: 'github',
      email: 'newbie@newbs.com',
      type: nil
    )

    assert_nil(not_a_merchant.type)
    expect(not_a_merchant).wont_be_instance_of Merchant

  end

describe "custom model method: is_a_merchant?" do
  let (:merchant) {merchants(:merchant)}

  it "returns true if model is merchant" do
    #Act/Assert
    expect(merchant).must_be_instance_of Merchant
    expect(merchant.is_a_merchant?).must_equal true
  end

  it "returns false if model is not a user" do
    #Arrange
    user = users(:cc_user)
    #Act/Assert
    expect(user).wont_be_instance_of Merchant
    expect(user.is_a_merchant?).must_equal false
  end

  it "flips from false to true if user becomes merchant" do
    user = users(:user1)

    expect(user.is_a_merchant?).must_equal false #testing turthiness of before value

    user.type = "Merchant"

    expect(user.is_a_merchant?).must_equal true #testing truthiness after change made
  end

  it "flops from true to false if a merchant becomes a user" do
    expect(merchant.is_a_merchant?).must_equal true #before

    #Assert
    merchant.type = nil

    assert_nil(merchant.type) #to be certain change in type made
    expect(merchant.is_a_merchant?).must_equal false #after

  end

end
end
