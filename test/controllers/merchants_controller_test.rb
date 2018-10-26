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


  describe "Logged in merchant" do

    before do
      @hells = merchants(:hells)
      perform_login(@hells)
    end


    it "signed in merchant can succesfully log out" do
      id = @hells.id

      delete merchant_path(id)

      expect(session[:merchant_id]).must_equal nil
      expect(flash[:success]).must_equal "Successfully logged out!"
      must_redirect_to root_path
    end


    it "should respond with not found for non-exsiting merchant" do

      random_non_existant_id = 333
      get merchant_path(random_non_existant_id)

      must_respond_with :missing
    end

    describe "status change" do

      it "logged in merchant can change their product status from activate to inactivate" do

        #get a product
        thyme = products(:thyme)
        #route with the id
        post status_change_path(thyme.id)

        thyme.reload

        expect(thyme.status).must_equal false

        #where it goes next
        must_redirect_to root_path
      end


      it "if logged in merchants try to change a product status that doesn't exist." do
        product = Product.first.id + 1


        post status_change_path(product)
        must_respond_with :not_found

      end

      it "if logged in merchants status change doesn't work." do
        product = Product.first
        product.status = "fake"


        post status_change_path(product)
        expect(product.status).must_equal true

      end




      # it "logged in merchant can not change the product status of another merchants" do
      #
      #   delete merchant_path(@hells.id)
      #
      #   @bake_off = merchants(:bake_off)
      #   perform_login(@bake_off)
      #
      #   get merchant_account_path(@hells.id)
      #
      #   must_respond_with :error
      #
      # end
    end

    describe "Merchant Add Products" do
      it "logged in merchant can successfully add a product" do

        get new_product_path

        must_respond_with :success
      end

      it "Not logged in merchant can not add a product" do

        delete merchant_path(@hells.id)

        must_redirect_to root_path

        get new_product_path

        flash[:status].must_equal :failure
        flash[:result_text].must_equal "Sign in as a merchant to access this page."
        must_respond_with :redirect

      end
    end

    describe "Merchant can ADD category" do
      it "logged in merchant can successfully add a category" do

        get new_category_path
        must_respond_with :success
      end

      it "A non logged in merchant can NOT add a category" do

        delete merchant_path(@hells.id)

        get new_category_path

        flash[:status].must_equal :failure
        flash[:result_text].must_equal "Sign in as a merchant to access this page."
        must_respond_with :redirect
      end

    end


    describe "Merchant Account Order Page" do


      it "logged in merchant can view their account orders" do
        get merchant_order_path
        must_respond_with :success
      end

      it "A Not logged in merchant can Not view their account orders" do
        delete merchant_path(@hells.id)

        get merchant_order_path
        must_respond_with :not_found
      end
    end

    it "logged in merchant can view their myaccount page" do
      get merchant_account_path
      must_respond_with :success
    end


    it "Not logged in merchant can Not view their myaccount page" do
      delete merchant_path(@hells.id)
      get merchant_account_path
      must_respond_with :not_found
    end

  end

end
