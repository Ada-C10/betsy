require "test_helper"

describe CategoriesController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end
  let(:wearables) { categories(:wearables) }
  let(:mercury) { merchants(:mercury) }

  describe 'add new category' do
    it 'lets a merchant add a new category' do
      merchants(:mercury)
      # binding.pry
      expect { post categories_path, params: {category: {category_name: "drinkables"}}}.must_change 'Category.count', 1
      must_respond_with :redirect
    end

    it 'doesnt let a guest access new category page' do
      get new_category_path
      must_respond_with :bad_request
    end

    it 'doesnt let a guest add a new category' do
      expect { post categories_path, params: {category: {category_name: "drinkables"}}}.must_change 'Category.count', 0
      must_respond_with :redirect
    end

    it 'must be a unique category' do
      merchants(:mercury)
      wearables.category_name.must_equal "wearables"
      expect { post categories_path, params: {category: {category_name: "wearables"}}}.must_change 'Category.count', 0
    end

    it 'does not allow  a blank name' do
      merchants(:mercury)
      expect { post categories_path, params: {category: {category_name: "   "}}}.must_change 'Category.count', 0

      post categories_path, params: {category: {name: ""}}
      must_respond_with :bad_request

    end
  end

  describe 'categories view routes' do
    it 'should get index' do
      get categories_path
      must_respond_with :success
    end
  end
end
