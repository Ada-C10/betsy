require "test_helper"

describe SessionsController do
  describe 'create' do
    it 'can sucessfully log in with github as an existing user' do
      merchant = merchants(:dogdays)

      perform_login(merchant)

      must_redirect_to root_path

      expect(session[:user_id]).must_equal merchant.id
      # expect(flash[:success]).must_equal "Logged in as merchant #{merchant.username}"
      # VNG - We need to fix flash.
    end

    it 'creates a new user sucessfully when logging in with a new valid user' do

      start_count = Merchant.count

      new_user = Merchant.new(username: "new user", email: "email@email.com", uid: 10, provider: "github")

      expect(new_user.valid?).must_equal true

      perform_login(new_user)

      must_redirect_to root_path

      expect(Merchant.count).must_equal start_count + 1

      expect( session[:user_id] ).must_equal Merchant.last.id

    end

    it 'does not create a new user when logging in with a new invalid user' do
      start_count = Merchant.count

      invalid_new_user = Merchant.new(username: nil, email: nil)

      expect(invalid_new_user.valid?).must_equal false

      perform_login(invalid_new_user)

      must_redirect_to root_path
      expect( session[:user_id] ).must_equal nil
      expect( Merchant.count ).must_equal start_count
    end
  end

  describe 'destroy' do
    it 'can log out a logged in user' do
      merchant = merchants(:dogdays)

      perform_login(merchant)

      delete logout_path(merchant)
      must_redirect_to root_path
    end
  end
end
