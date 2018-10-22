require "test_helper"

describe CategoriesController do
  let(:category) { categories(:africa) }

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

  describe "show" do
    it "should get a category's show page" do
      id = category.id

      get category_path(id)

      must_respond_with :success
    end

    it "should respond with not found if given an invalid id" do
      id = -1

      get category_path(id)

      must_respond_with :not_found
    end
  end

  describe "create" do
    it "creates a category" do
    end
  end

  describe "new" do
    it "succeeds" do
    end
  end

end
