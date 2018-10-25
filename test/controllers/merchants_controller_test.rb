require "test_helper"

describe MerchantsController do

  it "can successfully log in with github as an existing merchant" do
    iron_chef = merchants(:iron_chef)

    perform_login(iron_chef)

    must_redirect_to root_path
    expect(session[:merchant_id]).must_equal iron_chef.id
    # expect(flash[:status]).must_equal "Logged in as returning merchant #{merchant.name}"
  end

  it "can successfully log in with github as new merchant" do
    start_count = Merchant.count
    merchant = Merchant.new(provider: "github", uid: 293, name: "New Merchant", email: "new123@gmail.com")

    perform_login(merchant)

    must_redirect_to root_path

    Merchant.count.must_equal start_count + 1

    session[:merchant_id].must_equal Merchant.last.id
  end


  it "does not create a new merchant when logging in with a invalid data" do
    start_count = Merchant.count

    invalid_new_merchant = Merchant.new(name: nil, email: nil)

    expect(invalid_new_merchant.valid?).must_equal false

    perform_login(invalid_new_merchant)


    must_redirect_to root_path
    expect( session[:merchant_id] ).must_equal nil
    expect( Merchant.count ).must_equal start_count
  end




  describe "Logged in merchcants" do

    before do
      @hells = merchants(:hells)
      perform_login(@hells)
    end

    it "signed in merchant can succesfully log out" do

    end

    # it "shows my account page for a logged in merchant" do
    #
    #   get merchant_path(@hells.id)
    #   must_respond_with :success
    # end


    it "should show product change status" do

      #get a product
      thyme = products(:thyme)
      #route with the id
      post status_change_path(thyme.id)
      # binding.pry

      thyme.reload

      expect(thyme.status).must_equal false

      #where it goes next
      must_redirect_to root_path
    end


    it "should respond with not found for non-exsiting merchant" do

      get merchant_path(333)
      # redirect/render might send to a different status code
      must_respond_with :missing
    end



    it "logged in merchant can successfully add a product" do


    end


    it "logged in merchant can successfully add a category" do

    end

    it "logged in merchant can view their account orders" do

    end




  end

end
