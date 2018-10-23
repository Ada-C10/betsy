require "test_helper"

describe MerchantsController do

  it "can successfully log in with github as an existing merchant" do
    iron_chef = merchants(:iron_chef)

    perform_login(iron_chef)
    get merchant_callback_path(:github)

    must_redirect_to root_path
    expect(session[:merchant_id]).must_equal iron_chef.id
    # expect(flash[:status]).must_equal "Logged in as returning merchant #{merchant.name}"
  end

  it "can successfully log in with github as new merchant" do
    start_count = Merchant.count
    merchant = Merchant.new(provider: "github", uid: 293, name: "New Merchant", email: "new123@gmail.com")

    perform_login(merchant)
    get merchant_callback_path(:github)

    must_redirect_to root_path

    Merchant.count.must_equal start_count + 1

    session[:merchant_id].must_equal Merchant.last.id
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

  describe "Logged in merchcants" do

    before do
      perform_login(merchants(:hells))
    end









  end

end
