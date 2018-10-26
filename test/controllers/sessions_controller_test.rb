require "test_helper"

describe SessionsController do

  describe "login" do
    it "Can log in an existing user" do

    # Arrange
     user = users(:grace)

   # Tell OmniAuth to use this user's info when it sees
  # an auth callback from github
     OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
   #
   #   # Act
     expect {
       get auth_callback_path('github')
     }.wont_change('User.count')
   #
   #   # Assert
     must_redirect_to root_path
     expect(session[:user_id]).must_equal user.id
     must_respond_with :redirect
   end

   it "Can log in a new user with good data" do
     # Arrange
     user = users(:grace)
     user.destroy

     # Tell OmniAuth to use this user's info when it sees
     # an auth callback from github
     OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

     # Act
     expect {
       get auth_callback_path('github')
     }.must_change('User.count', +1)

     # Assert
     must_respond_with :redirect
     must_redirect_to root_path
     expect(session[:user_id]).wont_be_nil
   end

   it "Rejects a user with invalid data" do
     # Is still being added :(
     # Arrange
    user = User.new(
        name: "bob", uid: 234324343, provider: 'github'
       )

     # Tell OmniAuth to use this user's info when it sees
     # an auth callback from github
     OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

     # Making use have invalid data
     # Act - Will not change user count
       # Assert
       # Won't add a user to database
       expect {
         get auth_callback_path('github')
       }.wont_change("User.count")

       # Will flash an error - Can't save
       user.save
       expect(flash[:error]).must_equal "Could not create new user account: #{user.errors.messages}"
       # And redirect to root_path
       must_respond_with :redirect
       must_redirect_to root_path

   end
 end

  describe "logout" do

    it "can log a user out" do
      # Arrange
      #  Creating user / logging user in
       user = users(:grace)
       OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

       # Logging user in
       get auth_callback_path('github')
       # start_count = User.count

       # Act - Logging user out
       delete logout_path
       # user.destroy - don't think we destroy the user

       # Assert
       # Should set session usser id to nil
       expect(session[:user_id]).must_be_nil
       # Flash a message
       expect(flash[:success]).must_equal "Successfully logged out!"
       # And redirect to root_path
       must_respond_with :redirect
       must_redirect_to root_path
    end
   end




 end
