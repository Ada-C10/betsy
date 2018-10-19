require "test_helper"

describe ProductsController do
  let(:fred) { merchants(:fred) }

  describe "index" do
    it "succeeds when there are products" do
      get products_path

      must_respond_with :success
    end

    it "succeeds when there are no products" do
      products.each do |product|
        product.destroy
      end

      new_count = Product.all.count
      expect(new_count).must_equal 0

      get products_path

      must_respond_with :success
    end
  end

  describe "new" do
    it "succeeds given merchant id" do

      get "/auth/github"
      get new_merchant_product_path(fred.id)

      must_respond_with :success
    end
  end

  # describe "create" do
  #   it "creates a work with valid data for a real category" do
  #     expect {
  #       post works_path, params: work_hash
  #     }.must_change 'Work.count', 1
  #
  #     work = Work.find_by(title: "Titanic")
  #
  #     expect(flash[:status]).must_equal :success
  #     expect(flash[:result_text]).must_equal "Successfully created #{work_hash[:work][:category].singularize} #{work.id}"
  #
  #     must_respond_with :redirect
  #     must_redirect_to work_path(work.id)
  #   end
  #
  #   it "renders bad_request and does not update the DB for bogus data" do
  #     work_hash[:work][:title] = nil
  #
  #     expect {
  #       post works_path, params: work_hash
  #     }.wont_change 'Work.count'
  #
  #     expect(flash[:status]).must_equal :failure
  #     expect(flash[:result_text]).must_equal "Could not create #{work_hash[:work][:category].singularize}"
  #
  #     must_respond_with :bad_request
  #   end
  #
  #   it "renders 400 bad_request for bogus categories" do
  #     INVALID_CATEGORIES.each do |category|
  #       work_hash[:work][:category] = category
  #       expect {
  #         post works_path, params: work_hash
  #       }.wont_change 'Work.count'
  #
  #       expect(flash[:status]).must_equal :failure
  #       expect(flash[:result_text]).must_equal "Could not create #{work_hash[:work][:category].singularize}"
  #
  #       must_respond_with :bad_request
  #     end
  #   end
  # end
  #
  # describe "show" do
  #   it "succeeds for an extant work ID" do
  #     get work_path(works(:album).id)
  #
  #     must_respond_with :success
  #   end
  #
  #   it "renders 404 not_found for a bogus work ID" do
  #     id = -1
  #
  #     get work_path(id)
  #
  #     must_respond_with 404
  #   end
  # end
  #
  # describe "edit" do
  #   it "succeeds for an extant work ID" do
  #     get edit_work_path(works(:album).id)
  #
  #     must_respond_with :success
  #   end
  #
  #   it "renders 404 not_found for a bogus work ID" do
  #     id = -1
  #
  #     get edit_work_path(id)
  #
  #     must_respond_with 404
  #   end
  # end
  #
  # describe "update" do
  #   it "succeeds for valid data and an extant work ID" do
  #     id = works(:poodr).id
  #
  #     expect{
  #       patch work_path(id), params: work_hash
  #     }.wont_change 'Work.count'
  #
  #     work = Work.find_by(title: "Titanic")
  #     expect(flash[:status]).must_equal :success
  #     expect(flash[:result_text]).must_equal "Successfully updated #{work.category.singularize} #{work.id}"
  #
  #     must_respond_with :redirect
  #     must_redirect_to work_path(work.id)
  #
  #     expect(work.title).must_equal work_hash[:work][:title]
  #     expect(work.creator).must_equal work_hash[:work][:creator]
  #     expect(work.description).must_equal work_hash[:work][:description]
  #     expect(work.publication_year).must_equal work_hash[:work][:publication_year]
  #     expect(work.category).must_equal work_hash[:work][:category]
  #   end
  #
  #   it "renders bad_request for bogus data" do
  #     work_hash[:work][:title] = nil
  #
  #     id = works(:poodr).id
  #     old_poodr = works(:poodr)
  #
  #     expect {
  #       patch work_path(id), params: work_hash
  #     }.wont_change 'Work.count'
  #
  #     new_poodr = Work.find(id)
  #
  #     must_respond_with :bad_request
  #     expect(old_poodr.title).must_equal new_poodr.title
  #     expect(old_poodr.creator).must_equal new_poodr.creator
  #     expect(old_poodr.description).must_equal new_poodr.description
  #     expect(old_poodr.publication_year).must_equal new_poodr.publication_year
  #     expect(old_poodr.category).must_equal new_poodr.category
  #   end
  #
  #   it "renders 404 not_found for a bogus work ID" do
  #     id = -1
  #
  #     expect {
  #       patch work_path(id), params: work_hash
  #     }.wont_change 'Work.count'
  #
  #     must_respond_with 404
  #   end
  # end
  #
  # describe "destroy" do
  #   it "succeeds for an extant work ID" do
  #     work = works(:album)
  #     expect {
  #       delete work_path(work.id)
  #     }.must_change 'Work.count', -1
  #
  #     must_respond_with :redirect
  #     must_redirect_to root_path
  #
  #     expect(flash[:status]).must_equal :success
  #     expect(flash[:result_text]).must_equal "Successfully destroyed #{work.category.singularize} #{work.id}"
  #     expect(Work.find_by(id: work.id)).must_be_nil
  #   end
  #
  #   it "renders 404 not_found and does not update the DB for a bogus work ID" do
  #     id = -1
  #
  #     expect {
  #       delete work_path(id)
  #     }.wont_change 'Work.count'
  #
  #     must_respond_with 404
  #   end
  # end
  #
  # describe "upvote" do
  #
  #   it "redirects to the work page if no user is logged in" do
  #     work = works(:album)
  #     post upvote_path(work.id)
  #     must_respond_with :redirect
  #     must_redirect_to work_path(work.id)
  #   end
  #
  #   it "redirects to the root path after the user has logged out" do
  #     work = works(:album)
  #     user = users(:dan)
  #
  #     user_hash = {
  #       username: user.username
  #     }
  #
  #     post login_path, params: user_hash
  #     expect(session[:user_id]).must_equal user.id
  #
  #     get work_path(work.id)
  #
  #     post logout_path, params: user_hash
  #     expect(session[:user_id]).must_be_nil
  #
  #
  #     must_respond_with :redirect
  #     must_redirect_to root_path
  #   end
  #
  #   it "succeeds for a logged-in user and a fresh user-vote pair" do
  #     user = users(:kari)
  #     user_hash = {
  #       username: user.username
  #     }
  #
  #     post login_path, params: user_hash
  #     expect(session[:user_id]).must_equal user.id
  #
  #     work = works(:movie)
  #
  #     expect {
  #       post upvote_path(work.id)
  #     }.must_change 'Vote.count', 1
  #
  #     must_respond_with :redirect
  #     must_redirect_to work_path(work.id)
  #   end
  #
  #   it "redirects to the work page if the user has already voted for that work" do
  #     user = users(:kari)
  #     # Why isn't this a hash within a hash? Form Tag doesn't take in a model
  #     user_hash = {
  #       username: user.username
  #     }
  #
  #     post login_path, params: user_hash
  #     expect(session[:user_id]).must_equal user.id
  #
  #     work = works(:album)
  #
  #     expect {
  #       post upvote_path(work.id)
  #     }.wont_change 'Vote.count'
  #
  #     must_respond_with :redirect
  #     must_redirect_to work_path(work.id)
  #   end
  # end

end
