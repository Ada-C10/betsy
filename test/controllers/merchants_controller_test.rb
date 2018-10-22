require "test_helper"

describe MerchantsController do

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
      id = merchants(:kiki).id
      get dashboard_path(id)
      must_respond_with :found
    end

    it "should respond with not found if given a bad id" do
      id = -1
      get merchant_path(id)
      must_respond_with :not_found
    end

  end

end
