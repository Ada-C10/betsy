require "test_helper"

describe MerchantsController do
  let(:fred) {merchants(:fred)}

  it "should get index " do
    get merchants_path
    must_respond_with :success
  end

  describe "show" do
    it "should get a merchant's show page" do
      id = merchants(:kiki).id
      get merchant_path(id)
      must_respond_with :success
    end

    it "should respond with not found if given a bad id" do
      id = -1
      get merchant_path(id)
      must_respond_with :not_found
    end
  end

  describe "dashboard" do
    it "should get a merchant's dashboard" do
      perform_login(fred)
      get dashboard_path
      must_respond_with :success
    end

    it "should redirect to the root path if user is not logged in" do
      get dashboard_path

      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

end
