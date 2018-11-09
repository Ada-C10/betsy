require "test_helper"

describe ItemsController do

  before do
    @linda = users(:one)
  end

  describe 'index' do

    it "succeeds when there are items" do
      get items_path
      must_respond_with :success
    end

  end

  describe "show" do

    it "responds with success for showing an existing product" do

      test_item = items.first
      id = test_item.id

      get item_path(id)

      must_respond_with :success
    end

  end

  describe "new" do

    it "successful new page" do

      get new_item_path

      must_respond_with :success
    end

  end

  let (:logged_in_linda) {
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(@linda))

    get auth_callback_path(:github)
  }

  describe "create" do

    it "creates an item with valid data for a real logged in user and real category" do

      logged_in_linda
      # @current_user = @linda

      item_data = {
        item:
        {
          name: "A BRAND NEW THING",
          category_id: Category.first.id,
          price: 100,
          quantity_available: 100
        }
      }
      test_item = Item.new(item_data[:item])

      expect {
        post items_path, params: item_data

      }.must_change('Item.count', +1)

      must_redirect_to shop_path
    end

    it "renders bad_request and does not update the DB for bogus data" do

      logged_in_linda
      # @current_user = @linda

      item_data = {
        item:
        {
          name: "A BRAND NEW THING",
          category_id: Category.first.id
        }
      }

      test_item = Item.new(item_data[:item])

      expect {
        post items_path, params: item_data
      }.wont_change 'Item.count'

      must_respond_with :bad_request
      assert_equal "Item was not saved.", flash[:error]
    end

  end


  describe "edit" do

    it "responds with success for an existing item" do
      get edit_item_path(Item.first)

      must_respond_with :success
    end


  # Can't figure this one out :(
  # describe "update" do
  #
  #   it "successful update displays flash and redirects" do
  #     test_item = Item.create(name: "name",
  #       category: Category.first,
  #       user: User.first,
  #       price: 10,
  #       quantity_available: 10)
  #
  #       expect {test_item.update(name: "changed name")}.must_route_to shop_path
  #       # expect flash[:success].must_equal "Item successfully updated."
  #     end

end

describe 'destroy' do

  it 'destroy an existing item' do
    item = Item.create(name: "SOOO Unique", category: Category.first, user: User.first, price: 10, quantity_available: 10)
    # testing the database change
    expect {
      delete item_path(item)
    }.must_change('Item.count', -1)
    # testing the flash message
    expect flash[:success].must_equal "Item successfully deleted."
    # testing the path
    must_redirect_to root_path
  end

  it 'will not destroy an item that is part of an OrderItem' do
    @item = items(:shoes)
    @order = orders(:one)
    @new_order_item = OrderItem.create(order_id: @order.id, item_id: @item.id)

    item_count = Item.count

    delete item_path(@item)
    # database not changed
    expect(Item.count).must_equal item_count
    # flash error appears
    flash[:error].must_equal "Item cannot be deleted. There is a pending order with this item"
    # redirect back
    must_redirect_to root_path
  end

end

end
