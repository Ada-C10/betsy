require "test_helper"
describe CategoriesController do
  it "should get index" do
    get categories_path
    must_respond_with :success
  end

  describe "new" do
    it "can get the new category page" do

      @user = users(:tom)
      # Make fake session
      # Tell OmniAuth to use this user's info when it sees
      # an auth callback from github
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(@user))
      get auth_callback_path('github')

      get new_category_path

      must_respond_with :success
    end
  end

  describe "create " do
    let (:category_hash) do
      {
        category: {
          name: 'Werewolf'
        }
      }
    end


    it "can create a new category given valid params if logged in" do
      @user = users(:tom)
      # Make fake session
      # Tell OmniAuth to use this user's info when it sees
      # an auth callback from github
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(@user))
      get auth_callback_path('github')

      # Act-Assert
      expect {
        post categories_path, params: category_hash
      }.must_change 'Category.count', 1

      must_respond_with :redirect
      must_redirect_to dashboard_path(@user.id)

      expect(Category.last.name).must_equal category_hash[:category][:name]

    end

    it "does not allow guests to access the new category page" do
      user = users(:guest)
      get new_category_path
      expect(flash[:danger]).must_equal "You must be logged in to view this section"
      must_redirect_to root_path

    end

    it "responds with an error for invalid params" do

      @user = users(:tom)
      # Make fake session
      # Tell OmniAuth to use this user's info when it sees
      # an auth callback from github
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(@user))
      get auth_callback_path('github')

      category_hash[:category][:name] = nil

      expect {
        post categories_path, params: category_hash
      }.wont_change 'Category.count'

      must_respond_with :bad_request
    end

  end #end of create describe block

  describe "show" do
    it "should get a category's show page" do
      id = categories(:category1).id


      get category_path(id)

      must_respond_with :success
    end

    it "should get a not found page when category doesn't exist" do
      id = -2

      get category_path(id)

      must_respond_with :not_found
    end
  end

end #end of categoriescontroller do


# def show
#   @category = Category.find_by(id: params[:id])
#
#   if @cateogry.nil?
#     flash.now[:danger] = "Cannot find the category #{params[:id]}"
#     render :notfound, status: :not_found
#   end
# end
