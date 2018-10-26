require "test_helper"

describe CategoriesController do

  before do
    @merchant = merchants(:dogdays)
    perform_login(@merchant)
  end

  describe "new" do
    it 'should get new' do
      get new_category_path

      must_respond_with :success
    end
  end

  describe "create" do
    before do
      @category_data = {
        category: {
          name: 'test category'
        }
      }
    end
    it 'can create a new category with valid data' do

      test_category = Category.new(@category_data[:category])
      test_category.must_be :valid?, "Category is invalid. Please fix."

      expect{
        post categories_path, params: @category_data
      }.must_change('Category.count', +1)

      must_redirect_to dashboard_path(@merchant.id)

    end

    it 'does not create a new category with invalid data' do

      @category_data[:category][:name] = Category.first.name

      test_category = Category.new(@category_data[:category])
      test_category.wont_be :valid?, "Category is not invalid. Please fix."

      expect{
        post categories_path, params: @category_data
      }.wont_change('Category.count')

      must_respond_with :bad_request

    end
  end
end
