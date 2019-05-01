require "test_helper"

describe SessionsController do
  # it "should get login" do
  #   get login_path
  #   value(response).must_be :success?
  # end
  #
  # it "should get new" do
  #   get sessions_new_url
  #   value(response).must_be :success?
  # end
  #
  # it "should get destroy" do
  #   get sessions_destroy_url
  #   value(response).must_be :success?
  # end

  describe "auth_callback" do

    it "logs in an existing user" do
      start_count = User.count
      user = users(:grace)

      perform_login(user)

      must_redirect_to root_path
      expect(flash[:result_text]).must_match /Successfully logged*/
      session[:user_id].must_equal  user.id

      # Should *not* have created a new user
      User.count.must_equal start_count
    end

    it "can login in a new user with good data" do
      user = users(:ada)
      # remove ada test user from test db
      user.destroy
      # login ada as new user to test db
      perform_login(user)
      # user count should increase by 1
      expect do
        get auth_callback_path(:github).must_change('User.count' +1)
      end
      # redirect to root_path
      must_redirect_to root_path
      expect(flash[:result_text]).must_match /Successfully created*/
      expect(session[:user_id]).wont_be_nil
    end

    it "rejects an invalid user login with bad data" do
      user = users(:ada)
      user.uid = nil

      perform_login(user)

      expect do
        get auth_callback_path(:github).wont_change 'User.count'
      end

      must_respond_with :bad_request
      expect(session[:user_id]).must_be_nil

    end

    describe "logout" do
      it 'can log out' do
        user = users(:grace)

        perform_login(user)

        delete logout_path

        expect do
          get auth_callback_path(:github).wont_change 'User.count'
        end

        must_redirect_to root_path
        expect(session[:user_id]).must_be_nil

      end


    end
  end
end
