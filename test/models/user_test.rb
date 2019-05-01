require "test_helper"

describe User do
  # let(:user) { User.new }
  #
  # it "must be valid" do
  #   value(user).must_be :valid?
  # end

  describe "relations" do
    before do
      user = User.new
    end

    it "has a list of products" do

      user = product(:create)

      user.must_respond_to :product
      user.products.each do |product|
        product.must_be_kind_of Product
      end
    end

  end

  describe "validations" do
    it "requires a username" do
      user = User.new
      user.valid?.must_equal false
      user.errors.messages.must_include :username
    end

    it "requires a unique username" do
      username = "test username"
      user1 = User.new(username: username)
  
      # This must go through, so we use create!
      user1.save!

      user2 = User.new(username: username)
      result = user2.save
      result.must_equal false
      user2.errors.messages.must_include :username
    end


  end
end
