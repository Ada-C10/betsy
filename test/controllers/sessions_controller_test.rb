require "test_helper"

describe SessionsController do

  describe "login" do
    it "can successfully log in with githun as an exisiting user and redirects to root path" do

      #Arrange
      # Make sure that for some existing user, everything is configured

      merchant_one = merchants(:one)

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new( mock_auth_hash( merchant_one ) )

      #Act
      # Simulating logging in with github being successful (given the OmniAUth hash above)
      get auth_callback_path(:github)

      # Assert
      #Check that it redirects
      must_redirect_to root_path


      expect(flash[:success]).must_equal "Logged in as returning user #{merchant_one.username}"
    end

    it 'creates a new user successfully when logging in with a new valid merchant' do

      start_merch_count = Merchant.count

      new_merchant = Merchant.new(username: "nicodimos", uid: 56, provider: :github, email: "nico@zzz.com")

      expect(new_merchant.valid?).must_equal true

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new( mock_auth_hash( new_merchant) )

      get auth_callback_path(:github)

      must_redirect_to root_path
      expect( Merchant.count ).must_equal start_merch_count + 1
      expect( session[:merchant_id] ).must_equal Merchant.last.id
      expect( flash[:success] ).must_equal "Logged in Successfully. Welcome #{new_merchant.username}"
    end

    it 'does not create a new merchant when logging in with a new invalid merchant' do

      start_merch_count = Merchant.count

      invalid_new_merchant = Merchant.new(username: nil, uid: nil, provider: :github, email: "nico@zzz.com")

      expect(invalid_new_merchant.valid?).must_equal false

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new( mock_auth_hash( invalid_new_merchant ) )

      get auth_callback_path(:github)

      must_redirect_to root_path
      expect( Merchant.count ).must_equal start_merch_count
      expect( session[:merchant_id] ).must_equal nil
      expect( flash[:error] ).must_equal "Could not create new account: #{invalid_new_merchant.errors.messages}"
    end
  end
  describe 'logout' do
    before do
      merchant_one = merchants(:one)

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new( mock_auth_hash( merchant_one ) )

      get auth_callback_path(:github)
    end
    it 'can successfully logout by clearing the session' do

      post logout_path(session[:merchant_id])

      expect( session[:merchant_id]).must_equal nil
      expect( flash[:success] ).must_equal "Successfully logged out"
    end

    it 'should redirect to the root page' do
      post logout_path(session[:merchant_id])

      must_redirect_to root_path
    end
  end
end
