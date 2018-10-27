require "test_helper"

describe MerchantsController do
  describe "show" do
    let(:one) { merchants(:one) }
    let(:four) { merchants(:four) }

    it "goes to dashboard view when logged in" do
      login(one)
      get dashboard_path
      must_respond_with :success
    end
  end
end
