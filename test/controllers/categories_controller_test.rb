require "test_helper"
require 'pry'

describe CategoriesController do
  describe "logged in users" do
    before do
      merchant = merchants(:one)
      perform_login(merchant)
    end

    it "should be able to access new category page" do
      merchant = merchants(:one)
      perform_login(merchant)

      get new_category_path
      must_respond_with :success
    end

    it "should be able to create a new category with valid data" do
      data = {
        category: {
          name: 'zombie food'
        }
      }

      category = Category.new(data[:category])
      category.must_be :valid?
      expect {
        post categories_path, params: data
      }.must_change('Category.count', +1)

      must_respond_with :redirect
      must_redirect_to categories_path(Category.last)
    end

    it "should be responded with a bad request for a non-unique category name" do
      data = {category: {name: 'toy'}}

      category = Category.new(data[:category])
      expect {
        post categories_path, params: data
      }.wont_change('Category.count')

      must_respond_with :bad_request
    end
  end

  describe "guest users" do

    it "should not be able to access new category page" do
      get new_category_path
      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "should not be able to create a new category" do
      data = {category: {name: 'toy'}}

      category = Category.new(data[:category])
      expect {
        post categories_path, params: data
      }.wont_change('Category.count')

      must_respond_with :bad_request
    end
  end
end
