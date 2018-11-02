require "test_helper"

describe CategoriesController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end
  describe "new" do
    it "can get the new category page" do

      # Act
      get new_category_path

      # Assert
      must_respond_with :success
    end

    it "can get the form with the new_category_path" do
      # Arrange
      id = categories(:category1).id

      # Act
      get new_category_path(id)

      # Assert
      must_respond_with :success
    end
  end

  let (:category_hash) do
      {
        category: {
          name: 'Sports',
        }
      }
    end


    describe "create" do
      it "can create a new category given valid params" do
        # Act-Assert
        expect {
          post categories_path, params: category_hash
        }.must_change 'Category.count', 1

        must_respond_with :redirect
        must_redirect_to products_path


        expect(Category.last.name).must_equal category_hash[:category][:name]

      end

      it "responds with an error for invalid params" do
        # Arranges
        category_hash[:category][:name] = nil

        # Act-Assert
        expect {
          post categories_path, params: category_hash
        }.wont_change 'Category.count'

        must_respond_with :bad_request

      end
    end
end
