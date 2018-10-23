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
  end
end
