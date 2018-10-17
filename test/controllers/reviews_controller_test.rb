require "test_helper"

describe ReviewsController do
  it "should get new" do
    get reviews_new_url
    value(response).must_be :success?
  end

  it "should get create" do
    get reviews_create_url
    value(response).must_be :success?
  end

  it "should get edit" do
    get reviews_edit_url
    value(response).must_be :success?
  end

  it "should get update" do
    get reviews_update_url
    value(response).must_be :success?
  end

  it "should get destroy" do
    get reviews_destroy_url
    value(response).must_be :success?
  end

end
