require "test_helper"

describe Product do
  describe "relationships do" do

    it "has and belongs to many categories" do
      product = products(:lamb)
      category1 = categories(:mystical)
      category2 = categories(:dangerous)
      product.categories << category1
      product.categories << category2

      expect(product.categories.first).must_be_kind_of Category
      expect(product.categories.length).must_equal 2
    end

    it "belongs to a user" do
      @product = products(:lamb)

      tan = @product.user

      tan.must_be_kind_of User
    end
  end


  describe "validations do" do

    it "requires a name" do
      user = users(:tan)
      category = categories(:mystical)
      @product = Product.new(price: 20000, user_id: user.id, category_id: category.id)
      @product.valid?.must_equal false
      @product.errors.messages.must_include :name
    end

    it "requires a price" do
      user = users(:tan)
      category = categories(:mystical)
      @product = Product.new(name: "lamb", user_id: user.id, category_id: category.id)
      @product.valid?.must_equal false
      @product.errors.messages.must_include :price
    end

    it "adds product when price is a number" do
      user = users(:tan)
      category = categories(:mystical)
      @product = Product.new(name: "warthog", price: 3000, user_id: user.id, category_id: category.id, stock_count:4, photo_url:"https://i.imgur.com/eI9VU0v.jpg")
      @product.valid?.must_equal true
    end

    it "does not add a product when price is not a number" do
      user = users(:tan)
      category = categories(:mystical)

      @product = Product.new(name: "lamb", price: "xyz", user_id: user.id, category_id: category.id)
      @product.valid?.must_equal false
      @product.errors.messages.must_include :price
    end

    it "requires a unique name do" do
      @product1 = Product.new(name: "lamb", price: 2000)
      @product1.save
      @product2 = Product.new(name: "lamb", price: 3000)
      @product2.save


      @product2.valid?.must_equal false
    end

    it "adds a product when both name and price are present" do
      user = users(:tan)
      category = categories(:mystical)
      @product = Product.new(name: "warthog", price: 3000, user_id: user.id, category_id: category.id, stock_count:4, photo_url:"https://i.imgur.com/eI9VU0v.jpg")
      @product.valid?.must_equal true
    end

    it "has a list of reviews" do
      @product = products(:lamb)
      @product.must_respond_to :reviews

      @product.reviews << reviews(:one)
      @product.reviews.each do |review|
        review.must_be_kind_of Review
      end
    end

  end

describe "custom methods" do

  it "adjusts stock count according to products sold" do

    product = products(:lamb)

    Product.adjust_stock_count(product.id, 2)
    product.reload
    expect(product.stock_count).must_equal 8
  end

  it "gives average rating for review" do

     product = products(:lamb)
     rating = product.average_rating

    expect(rating).must_equal 3
  end

  it "checks if product is in cart already" do
    product = products(:lamb)
    session = [{product.id=>3}]
    cart = product.in_cart?(session)
    expect(cart).must_equal true
  end

  it "checks if product is not in cart already" do
    product = products(:lamb)
    session = [{-1=>3}]
    cart = product.in_cart?(session)
    expect(cart).must_equal false
  end

  it "checks if cart quantity gets updated" do
    product = products(:lamb)
    session = [{product.id=>3}]
    cart = product.cart_adjust_quantity(session)
    expect(cart).must_equal 7
  end

end
end
