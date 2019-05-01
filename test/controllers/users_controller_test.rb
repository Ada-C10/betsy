require "test_helper"

describe UsersController do
  let(:user) { users :ada }

  it "gets new" do
    get new_user_url
    value(response).must_be :successful?
  end

  it "creates user" do
    user_hash= {
      user: {
      email: 'user3@gmail.com',
      uid: 2,
      username: 'newuser'
      }
    }
    expect {
      post users_path, params: user_hash
    }.must_change "User.count", 1

    must_redirect_to root_path
  end


  # User test are create and and show order fulfillment if logged in
  describe "Logged in users" do
    before do
      perform_login(users(:grace))
    end

    describe "show" do
      # Just the standard show tests
      it "succeeds for logged in user" do
        get user_path(session[:user_id])
        must_respond_with :success

      end

      it "returns 404 a user who is not the logged in user" do
        a = users(:ada)
        a_id = a.id
        get user_path(a_id)
        must_redirect
      end
    end

    # can change an items status to shipped
    # can add new products
    # can retire a product

  end

  describe "Guest users" do
    # it "returns 404 a user who is not the logged in user" do
    #   get user_path(session[:user_id] - 1)
    #   must_respond_with :forbidden
    # end



  end
end


