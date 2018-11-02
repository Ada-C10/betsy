require "test_helper"

describe SessionsController do
  describe "create" do
    #remember merchants are a subclass of user, so will be included in count as well
    it "Can log in an existing user" do
      # Arrange
      user = users(:cc_user)

      #Act/Assert
      expect {perform_login(user)}.wont_change('User.count')
      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
    end

    it "Can log in a new user with good data" do
      # Arrange
      user = users(:no_order_user)
      user.destroy

      #Act/Assert
      expect{perform_login(user)}.must_change('User.count', -1)
      must_redirect_to edit_user_path(session:user_id)
      expect(session[:user_id]).wont_be_nil
    end

    it "Rejects a user with invalid data" do

    end
  end
end
