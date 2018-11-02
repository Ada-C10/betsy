require "test_helper"

describe UsersController do
  let(:user) {users(:user1)}

  # describe Merchant do
  #
  #   it "should allow edits to own products" do
  #
  #   end
  #
  #   it "should not allow type-merchant to purchase own products" do
  #
  #
  #
  #   end
  #
  #   it "allows a merchant to downgrade to a regular user" do
  #
  #   end
  #
  # end #merchant tests end

  it "logs in an existing user" do
    start_count = User.count

    perform_login(user)
    session[:user_id].must_equal user.id

    # Should *not* have created a new user
    User.count.must_equal start_count
  end

  it "assigns instances created with User.new with type: 'Merchant' to the Merchant subclass" do
    #testing User.new with type: Merchant rather than Merchant.new
    user = User.new(name: "Sadie", type: "Merchant", uid: 98900, provider: "sovietski")

    expect(user).must_be_instance_of Merchant
    expect(user).must_be_kind_of User
    expect(user).wont_be_instance_of User
  end

  # it "does not allow edits to products" do
  #
  # end
  #
  # it "does not allow deletion of products" do
  #
  # end
  #
  # it "allows user to edit quantity in order(shopping cart)" do
  #
  # end
  #
  # it "allows user to remove items to cart" do
  #
  # end
  #
  # it "allows user to add items to cart" do
  #
  # end
  #
  # it "allows user to edit their user information" do
  #
  # end
  #
  # it "allows a user to become a merchant" do
  #
  # end


  # it "should get index" do
  #   get user_index
  #   value(response).must_be :success?
  # end
  #
  # it "should get new" do
  #   get user_new
  #   value(response).must_be :success?
  # end
  #
  # it "should get show" do
  #   get user_show
  #   value(response).must_be :success?
  # end
  #
  # it "should get update" do
  #   get user_update
  #   value(response).must_be :success?
  # end
  #
  # it "should get destroy" do
  #   get user_destroy
  #   value(response).must_be :success?
  # end
  #
  # it "should get edit" do
  #   get user_edit
  #   value(response).must_be :success?
  # end
  #
  # it "should get create" do
  #   get user_create
  #   value(response).must_be :success?
  # end

end
