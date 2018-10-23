require "test_helper"

describe MerchantsController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end

  it "can successfully log in with github as an existing merchant" do

    iron_chef = merchants(:iron_chef)

    perform_login(iron_chef)
    get merchant_callback_path(:github)

    must_redirect_to root_path
    expect(session[:merchant_id]).must_equal iron_chef.id
    # expect(flash[:status]).must_equal "Logged in as returning merchant #{merchant.name}"
  end


  it "does not create a new user when logging in with a new invalid merchant" do
    start_count = Merchant.count

    invalid_new_merchant = Merchant.new(name: nil, email: nil)

    expect(invalid_new_merchant.valid?).must_equal false

    perform_login(invalid_new_merchant)

    get merchant_callback_path(:github)

    must_redirect_to root_path
    expect( session[:merchant_id] ).must_equal nil
    expect( Merchant.count ).must_equal start_count
  end




end
