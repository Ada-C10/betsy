require "test_helper"

describe CategoriesController do

  let(:bad_category_id) { Category.first.destroy.id }

  describe "Logged in merchants" do

    before do
      perform_login(merchants(:bake_off))
    end

    describe "access for logged in merchants" do

      it "logged in merchants can access the show page for a category" do
        category_id = Category.first.id
        get category_path(category_id)
        must_respond_with :success
      end

      it "logged in merchants can access the new category form" do
        get new_category_path
        must_respond_with :success
      end
    end

    describe "update-ability for logged-in merchants" do
      describe "create" do
        it "creates a category with valid data" do

          category_data = {
            category: {
              name: "Fuzzy bunnies"
            }
          }

          expect {
            post categories_path, params: category_data
          }.must_change('Category.count', +1)

          must_redirect_to category_path(Category.last)
        end

        it "will not create a category, given incomplete data" do

          category_data = {
            category: {
              name: nil
            }
          }

          expect {
            post categories_path, params: category_data
          }.wont_change ('Category.count')

        end
      end
    end
  end

  describe "Guest users" do
    describe "access for guest users" do
      it "guest users can access the show page for a category" do
        category_id = Category.first.id
        get category_path(category_id)
        must_respond_with :success
      end

      it "guest users cannot access the new category form" do
        get new_category_path
        must_redirect_to root_path
        flash[:status].must_equal :failure
      end
    end
  end
end
