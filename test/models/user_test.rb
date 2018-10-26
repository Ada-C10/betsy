require "test_helper"

describe User do
  let(:user) { users(:dani) }

  it "must be valid" do
    expect(user).must_be :valid?
  end

  it "must have required fields" do
    fields = [:name, :email, :photo, :uid, :provider]

    fields.each do |field|
      expect(user).must_respond_to field
    end
  end

  describe 'Relationships' do

    it 'can have many products' do
      user.products << Product.first
      products = user.products

      expect(products.length).must_be :>=, 1
      products.each do |product|
        expect(product).must_be_instance_of Product
      end

    end

    it 'can have many orders' do
      user.orders << Order.first
      orders = user.orders

      expect(orders.length).must_be :>=, 1
      orders.each do |order|
        expect(order).must_be_instance_of Order
      end
    end
  end
  describe 'Validations' do
    it 'must have name' do
        user = users(:dani)
        user.name = nil

        valid = user.save
        expect(valid).must_equal false
        expect(user.errors.messages).must_include :name

    end

    it 'must have valid email' do
      invalid_emails = [nil , "@", "dan"]

      user = users(:dani)

      invalid_emails.each do |invalid_email|
        user.email = invalid_email

        valid = user.save
        expect(valid).must_equal false
        expect(user.errors.messages).must_include :email
      end
    end

    it 'must have a unique email' do
      user = users(:dani)
      user2 = users(:kay)
      user2.email = user.email

      valid = user2.save
      expect(valid).must_equal false
      expect(user2.errors.messages).must_include :email
    end

  end

  describe "find my products" do
    before do
      # Make a merchant with no products
        @merchant = User.create(
          name: "Cassy",
          email: "casy@g.com",
          uid: 234343434,
          provider: 'github'
        )
        # Logging user in
        # OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
        # get auth_callback_path('github')

    end
    it "returns an empty array if I have no products" do
      # Merchant has no products
      @merchant.sold_items.must_be_instance_of Array
      @merchant.sold_items.length.must_equal 0

    end

    it "returns an empty array if my products have no items" do
      # Add a product to a merchant but have no ordersitems
      product = Product.create(
        name: "Spooky House",
        price: 1000000,
        description: "Most spooky house ever!",
        stock: 3,
        user_id: @merchant.id
      )

      @merchant.products << product
      @merchant.products.length.must_equal 1
      @merchant.products.first.must_equal product
      @merchant.sold_items.must_be_instance_of Array
      @merchant.sold_items.length.must_equal 0
    end

    it "returns my order items" do
      # Add two products to a merchant, each with orders items
      # Product one
      # order item
      # order item
      # product two
      # order item
      # order item

      product_one = Product.create(
        name: "Spooky House One",
        price: 1000000,
        description: "Most spooky house ever!",
        stock: 3,
        user_id: @merchant.id,
        photo: "product_one_photo"
      )

      product_two = Product.create(
        name: "Spooky House Two",
        price: 1000000,
        description: "Most spooky house ever!",
        stock: 3,
        user_id: @merchant.id,
        photo: "product_two_photo"
      )

      # Do I need to shovel order items into product?
      product_one.orders_items << OrdersItem.create(
        order_id: orders(:one).id,
        quantity: 3
      )

      product_two.orders_items << OrdersItem.create(
        order_id: orders(:one).id,
        quantity: 2
      )

      product_one.orders_items.length.must_equal 1
      product_one.orders_items.first.must_be_instance_of OrdersItem
      product_one.orders_items.first.order_id.must_equal orders(:one).id
      product_one.orders_items.first.quantity.must_equal 3
      product_two.orders_items.length.must_equal 1
      product_two.orders_items.first.must_be_instance_of OrdersItem
      product_two.orders_items.first.order_id.must_equal orders(:one).id
      product_two.orders_items.first.quantity.must_equal 2


    end
  end

end
