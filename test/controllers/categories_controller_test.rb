require "test_helper"

describe CategoriesController do
  describe "index" do
    it "suceeds when there are categories" do
      get categories_path

      must_respond_with :success
    end

    it "suceeds when there are no categories" do
      categories.each do |category|
        category.destroy
      end

      new_count = Category.all.count
      expect(new_count).must_equal 0

      get categories_path

      must_respond_with :success
    end
  end
end
