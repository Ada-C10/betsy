require "test_helper"

describe CategoriesController do

  let (:category_hash) do
     {
  category: {
    name: "Snake",
    }}
  end

  let (:wrong_hash) do
     {
  category: {
    name: nil,
    }}
  end

describe "index" do
  it "should get index" do
    get categories_path
    must_respond_with :success
  end
end

describe "show" do
  it "will get show for valid ids" do
    id = categories(:mystical).id

    get category_path(id)
    must_respond_with :success
  end

  it "will respond with not_found for invalid ids" do
    id = categories(:mystical)
    categories(:mystical).destroy

    get category_path(id)
    must_respond_with :not_found
  end
end

describe "new" do
  it "will load the new category" do
    kit =users(:kit)
    perform_login(kit)

    get new_category_path
    must_respond_with :success
  end
end


  describe "create" do
    it "can create a category" do
      expect {
        post categories_path, params: category_hash
      }.must_change 'Category.count', 1

      must_respond_with  :redirect

      expect(Category.last.name).must_equal category_hash[:category][:name]
    end

    it "cannot create a category with invalid data" do
      expect {
        post categories_path, params: wrong_hash
      }.wont_change 'Category.count'

      must_respond_with  :bad_request

    end
end
end
