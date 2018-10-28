require 'test_helper'

describe UsersController do

  describe "index" do
    it "succeeds when there are users" do
      get users_path

      must_respond_with :success
    end

    it "succeeds when there are no users" do
      users = User.all
      User.all.each do |user|
        user.destroy
      end

      get users_path
      must_respond_with :success
    end
  end

  describe "show" do
      it "succeeds for an existing user" do
        id = users(:tan).id

        get user_path(id)

        must_respond_with :success
      end

      it "renders 404 not_found for a bogus user ID" do
        id = -1
        get user_path(id)
        must_respond_with :not_found
      end
    end
end
