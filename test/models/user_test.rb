require "test_helper"

describe User do

  let(:user) { users(:user1) }

  it "must be valid" do
    value(user).must_be :valid?
  end

  describe "custom model method: is_a_merchant?" do #this method is imparted to Merchant model
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

  describe "custom model method: become Merchant" do
    let(:user) { users(:cc_user) }

    it "changes a user instance into a merchant instance if type is set to Merchant" do
      #before!
      assert_nil(user.type) #making sure type is nil
      expect(user).must_be_instance_of User #user is a User

      #Arrange
      user.type = "Merchant"
      user.become_merchant #the method to switch the STI class of instance

      #after!
      expect(user.type).must_equal "Merchant" #type has changed from nil
      expect(user).wont_be_instance_of User  #user is no longer a User instance
      expect(user).must_be_instance_of Merchant #user has been changed into an instance of Merchant

    end

  end

end
