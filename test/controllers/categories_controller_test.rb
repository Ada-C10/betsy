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

  describe "create" do
    it "creates a category" do
      category_hash = {
        name:(South America)

      expect{post catergories_path}



    end
  end

  describe "new" do
    it "succeeds" do
      get catergories_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "should show product's category" do
    end
  end

end
