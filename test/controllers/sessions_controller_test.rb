require "test_helper"

describe SessionsController do
  describe "auth_callback" do
    it "Can log in an existing merchant" do
      merchant = merchants(:kiki)
      perform_login(merchant)
      expect{
        get auth_callback_path('github')

      }.wont_change('Merchant.count')

      must_redirect_to root_path
      expect(session[:user_id]).must_equal merchant.id

    end

    it "can log in a new merchant with good data" do
      start_count = Merchant.count
      merchant = Merchant.create(provider: 'github', uid: 2343, name: "test", email: "email@email")
      perform_login(merchant)
      must_redirect_to root_path

      Merchant.count.must_equal start_count + 1
      expect(session[:user_id]).must_equal Merchant.last.id


    end

    it "rejects a user with invalid data" do
      merchant = Merchant.create(provider: 'github', uid: 2343, name: nil, email: "email@email")
      OmniAuth.config.mock_auth[:github] =
      OmniAuth::AuthHash.new(mock_auth_hash(merchant))

      expect{
        get auth_callback_path('github')

      }.wont_change('Merchant.count')


      expect(session[:user_id]).must_be_nil

    end
    end

    describe "destroy" do
      it "ends a session" do
        merchant = merchants(:kiki)
        perform_login(merchant)
        expect{
          delete logout_path(merchant)
        }.wont_change ('Merchant.count')
        must_redirect_to root_path

        expect(session[:user_id]).must_be_nil

      end
    end


end
