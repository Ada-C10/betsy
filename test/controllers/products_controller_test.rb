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

      perform_login(fred)
      get new_merchant_product_path(fred.id)

      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a work with valid data" do
      perform_login(fred)
      product_hash = {
      product: {
        name: "Peru",
        cost: 1890,
        image_url: "image",
        inventory: 3,
        description: "The owls are not what they seem.",
        active: true,
        merchant_id: fred.id

      }
    }

    expect{
      post products_path, params: product_hash}.must_change 'Product.count', 1


    must_respond_with :redirect

    expect(Product.last.name).must_equal product_hash[:product][:name]
    expect(Product.last.cost).must_equal product_hash[:product][:cost]
    expect(Product.last.image_url).must_equal product_hash[:product][:image_url]
    expect(Product.last.inventory).must_equal product_hash[:product][:inventory]
    expect(Product.last.description).must_equal product_hash[:product][:description]
    expect(Product.last.active).must_equal product_hash[:product][:active]
    expect(Product.last.merchant_id).must_equal product_hash[:product][:merchant_id]


  end

    it "renders bad_request and does not update the DB for bogus data" do
      perform_login(fred)
      product_hash = {
      product: {
        name: "Peru",
        cost: 1890,
        image_url: "image",
        inventory: 3,
        description: "The owls are not what they seem.",
        active: true,
        merchant_id: fred

      }
    }
      product_hash[:product][:name] = nil

      expect {
        post products_path, params: product_hash
      }.wont_change 'Product.count'

      expect(flash[:status]).must_equal :failure


      must_respond_with :bad_request
    end



  describe "show" do
    it "succeeds for an extant product ID" do
      get products_path(products(:safari).id)

      must_respond_with :success
    end

    it "renders 404 not_found for a bogus work ID" do
      id = -1

      get product_path(id)

      must_respond_with 404
    end
  end

  describe "edit" do
    it "succeeds for an extant product ID" do
      perform_login(fred)
      get edit_merchant_product_path(merchants(:fred),products(:safari).id)

      must_respond_with :success
    end

    it "renders 404 not_found for a bogus work ID" do
      perform_login(fred)
      products(:safari).id = -1

      get edit_merchant_product_path(merchants(:fred),products(:safari).id)

      must_respond_with 404
    end
  end

  describe "update" do
    let (:product_hash)  { {
      product: {
        name: "Peru",
        cost: 1890,
        image_url: "image",
        inventory: 3,
        description: "The owls are not what they seem.",
        active: true,
        merchant_id: merchants(:fred).id

      }
    }
  }
    it "succeeds for valid data and an extant product ID" do
      perform_login(fred)
      id = products(:fannypack).id

      expect{
        patch product_path(id), params: product_hash
      }.wont_change 'Product.count'
      must_respond_with :redirect
      flash[:status] = :success


      product = Product.find_by(id: id)
      expect(product.name).must_equal product_hash[:product][:name]
      expect(product.cost).must_equal product_hash[:product][:cost]
      expect(product.image_url).must_equal product_hash[:product][:image_url]
      expect(product.inventory).must_equal product_hash[:product][:inventory]
      expect(product.description).must_equal product_hash[:product][:description]
      expect(product.active).must_equal product_hash[:product][:active]
      expect(product.merchant_id).must_equal product_hash[:product][:merchant_id]

    end


    it "renders bad_request for bogus data" do
      perform_login(fred)
      product_hash[:product][:name] = nil

      id = products(:fannypack).id
      old_fannypack = products(:fannypack)

      expect {
        patch product_path(id), params: product_hash
      }.wont_change 'Product.count'

      new_fannypack = Product.find(id)

      must_respond_with :bad_request
      expect(old_fannypack.name).must_equal new_fannypack.name
      expect(old_fannypack.cost).must_equal new_fannypack.cost
      expect(old_fannypack.image_url).must_equal new_fannypack.image_url
      expect(old_fannypack.inventory).must_equal new_fannypack.inventory
      expect(old_fannypack.description).must_equal new_fannypack.description
      expect(old_fannypack.active).must_equal new_fannypack.active
      expect(old_fannypack.merchant_id).must_equal new_fannypack.merchant_id

    end

    it "responds with not found for a bogus product ID" do
      perform_login(fred)
      id = -1

      expect {
        patch product_path(id), params: product_hash
      }.wont_change 'Product.count'

      must_respond_with :not_found

    end
  end


  describe "destroy" do
    it "succeeds for an extant product ID" do
      perform_login(fred)
      product = products(:fannypack)
      expect {
        delete merchant_product_path(merchants(:fred),products(:fannypack).id)
      }.wont_change 'Product.count'

      must_respond_with :redirect
      must_redirect_to root_path


      expect(Product.find_by(id: product.id).active).must_equal false
    end
  end

    it "renders 404 not_found and does not update the DB for a bogus work ID" do
      perform_login(fred)
      product = products(:fannypack)
      product.id = -1

      expect {
        delete merchant_product_path(merchants(:fred),products(:fannypack).id)
      }.wont_change 'Product.count'


      must_respond_with 404
    end
  end



end
