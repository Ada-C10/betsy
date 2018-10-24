require "test_helper"

describe SearchController do
  describe "search" do
    it "suceeds when the search is successful" do
      search_params = {
        search: "fanny"
      }

      get search_path, params: search_params

      must_respond_with :success
    end

    it "suceeds when the search finds no matches" do
      search_params = {
        search: "kpop"
      }

      get search_path, params: search_params

      must_respond_with :success
    end

    it "suceeds when nothing is entered into the search" do
      get search_path

      must_respond_with :success
    end
  end

  describe "find_order" do
    let(:order) { orders(:ordciara) }
    let(:order2) { orders(:ordrussell)}

    it "finds the order with a matching order id and email" do
      search_params = {
        id: order.id,
        email: order.email
      }
      post find_order_path, params: search_params

      must_respond_with :redirect
      must_redirect_to order_path(order.id)
    end

    it "redirects to the root path if order is not found" do
      search_params = {
        id: nil,
        email: order.email
      }

      post find_order_path, params: search_params

      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "redirects to the root path if order id and email do not match" do
      search_params = {
        id: order.id,
        email: order2.email
      }

      post find_order_path, params: search_params

      must_respond_with :redirect
      must_redirect_to root_path
    end
  end
end
