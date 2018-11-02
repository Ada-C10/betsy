require "test_helper"

describe HomeController do
  describe "index" do
    it "succeeds" do
      # Act
      get root_path

      # Assert
      must_respond_with :success
    end
  end
end
