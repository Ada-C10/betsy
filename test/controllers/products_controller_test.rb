require "test_helper"

describe ProductsController do
  let(:one) {merchants(:one)}
  let(:bad_product_id) {Product.first.destroy.id}

  describe 'index' do
    it "should get index for a guest" do
      get products_path
      must_respond_with :success
    end

    it "should get index for a logged-in user" do
      login(one)
      get products_path
      must_respond_with :success
    end

  end

  describe 'show' do
    it "should get show for a guest" do
      id = products(:puzzle)
      get product_path(id)
      must_respond_with :success
    end

    it "should get show for a logged-in user" do
      login(one)
      id = products(:puzzle)
      get product_path(id)
      must_respond_with :success
    end

    it "should respond with not found for showing a non-existing product for a guest" do
      get product_path(bad_product_id)
      must_respond_with :not_found
    end

    it "should respond with not found for showing a non-existing product for a logged-in user" do
      login(one)
      get product_path(bad_product_id)
      must_respond_with :not_found
    end
  end

  describe 'new' do
    it 'should get a new form to add products' do
      login(one)
      get new_merchant_product_path(one.id)
      must_respond_with :success
    end
  end

  describe 'create' do
    it 'it can create a product with valid data' do
      login(one)
      product_data = {
        product: {
          name: "some toy",
          price: 25,
          inventory: 10,
          merchant_id: one.id,
          description: "An integlligent brain plushie",
          category_ids: [categories(:toy).id]
        }
      }

      test_product = Product.new(product_data[:product])
      valid = test_product.valid?
      valid.must_equal true, "Product data was invalid: #{test_product.errors.messages}, please come fix this test"

      expect{
        post merchant_products_path(one.id), params: product_data
      }.must_change('Product.count', +1)

      must_redirect_to product_path(Product.last)
    end

    it 'does not create a new product with invalid data' do
      login(one)

      product_data = {
        product: {
          merchant: merchants(:one),
          category_ids: [categories(:toy).id]
        }
      }

      Product.new(product_data[:product]).wont_be :valid?

      expect {
        post(merchant_products_path(one.id), params: product_data)
      }.wont_change('Product.count')

      must_respond_with :bad_request
    end
  end

  describe "edit" do
    it "responds with success for an existing book" do
      login(one)
      product = Product.first
      get edit_merchant_product_path(one.id, product.id)
      must_respond_with :success
    end

    it "responds with not_found for a book that D.N.E." do
      login(one)
      get edit_merchant_product_path(one.id, bad_product_id)
      must_respond_with :not_found
    end
  end

  describe 'update' do
    it "updates with valid data with a logged-in user" do
      login(one)

      existing_product = products(:puddy)

      put merchant_product_path(one.id, existing_product.id), params: {
        product: {
          name: "Brain Puddy UPDATED",
          price: 14,
          description: "Updated Description!",
          inventory: 100
        }
      }

      updated_product = Product.find_by(id: existing_product.id)

      updated_product.name.must_equal "Brain Puddy UPDATED"
      must_respond_with :redirect
      must_redirect_to product_path(updated_product.id)
    end

    it "fails for bogus data and aproduct with a logged-in user" do
      login(one)

      existing_product = products(:puddy)

      put merchant_product_path(one.id, existing_product.id), params: {
        product: {
          name: "",
          price: 14,
          description: "Updated Description!",
          inventory: 100
        }
      }

      unchanged_product = Product.find_by(id: existing_product.id)

      unchanged_product.name.must_equal "Brain Puddy"
      must_respond_with :bad_request
    end
  end

  describe 'change product status' do
    it 'it should change the status with post request' do
      login(one)

      existing_product = products(:puddy)

      post change_status_merchant_product_path(one.id, existing_product.id), params: {
        product: {
          name: "Brain Puddy",
          price: 14,
          description: "Description!",
          inventory: 100,
          is_active: false
        }
      }

      updated_product = Product.find_by(id: existing_product.id)

      updated_product.is_active.must_equal false
      must_redirect_to dashboard_path
    end
  end
end
