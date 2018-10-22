require "test_helper"

describe UsersController do
  describe "new" do
    it "should get new" do
      # Act
      get new_user_path
      # Assert
      must_respond_with :success
    end
  end


  describe "dashboard" do
    it "should get dashboard if you are a logged in merchant/it's your dashboard" do
      # Arrange
      user = users(:tom)
      id = users(:tom).id
      # Act
      get dashboard_path(id)
      # Assert
      must_respond_with :success
    end

    # it "should respond with not_found if given an invalid id" do
    #   # Arrange
    #   id = -1
    #
    #   # Act
    #   get dashboard_path(id)
    #
    #   #Assert
    #   must_respond_with :not_found
    #   expect(flash[:danger]).must_equal "Cannot find the user -1"
    # end



    it "should respond with not_found if given an invalid id" do
      # Invalid is anything but the merchant's id
      # Arrange - Not tom's id
      id = -1

      # Act
      get dashboard_path(id)

      #Assert
      must_respond_with :not_found
      expect(flash[:danger]).must_equal "Cannot find user"
    end
  end

  describe "create" do
    let (:user_hash) do
      {
        user: {
          name: 'Bob',
          email: 'bob@gmail.com',
          photo: 'bobsphoto'
        }
      }
    end

    it "can create a new user given valid params" do
      # Says it's redirect is a users . instead of users/, not sure why
      # binding.pry
      expect {
        post users_path, params: user_hash
      }.must_change 'User.count', 1

        must_respond_with :redirect
        must_redirect_to root_path

        expect(User.last.name).must_equal user_hash[:user][:name]
        expect(User.last.email).must_equal user_hash[:user][:email]
        # For some reason photo is not coming through/is nil
        # Is in user hash but doesn't seem to carry over
        expect(User.last.photo).must_equal user_hash[:user][:photo]
        expect(User.last.uid).must_equal user_hash[:user][:uid]
        expect(User.last.provider).must_equal user_hash[:user][:provider]
    end

    it "responds with an error for invalid params" do
      # Arrange
      user_hash[:user][:name] = nil
      # binding.pry
      #Act/Assert
      expect {
         post users_path, params: user_hash
       }.wont_change 'User.count'

       # Says the count changed :(

       must_respond_with :bad_request

    end
  end
end
