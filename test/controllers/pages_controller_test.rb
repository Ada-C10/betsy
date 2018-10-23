require "test_helper"

describe PagesController do
  describe "home" do
    it "suceeds to show the home page" do
      get root_path

      must_respond_with :success
    end
  end
end
