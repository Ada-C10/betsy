require "test_helper"

describe User do
  describe "relations" do
    let(:kit) { users(:kit) }
    let(:tan) { users(:tan) }

    it "has a list of products" do
      kit.must_respond_to :products

      kit.products.each do |product|
        product.must_be_kind_of Product
      end
    end

    it "has a list of orders" do
      tan.must_respond_to :orders

      tan.orders.each do |order|
        order.must_be_kind_of Order
      end
    end

    it "has a list of orderproducts" do
      tan.must_respond_to :orderproducts

      tan.orderproducts.each do |orderproduct|
        orderproduct.must_be_kind_of Orderproduct
      end
    end
  end

  describe "validations" do
    it  "requires a name and email" do
      user = User.new
      user.valid?.must_equal false
      user.errors.messages.must_include :name, :email
    end

    it  "requires a unique user name and email" do
      user1 = User.new(name: 'mat', email: 'mat@gmail.com', uid: 1234, provider: 'github')
      user1.save!

      user2 = User.new(name: 'mat', email: 'mat@gmail.com', uid: 1234, provider: 'github')
      result = user2.save

      result.must_equal false
      user2.errors.messages.must_include :name, :email
    end
  end

  describe 'custom methods' do

    describe 'build_from_github(auth_hash)' do

      it "builds a user from auth_hash" do
        test_auth_hash = {
          uid: 12345,
          "info" => {
            "email" => "joke@joke.com",
            "name" => "Faker"
          }
        }
        new_user = User.build_from_github(test_auth_hash)

        expect(new_user.uid.must_equal test_auth_hash[:uid])
        expect(new_user.email.must_equal test_auth_hash['info']['email'])
        expect(new_user.name.must_equal test_auth_hash['info']['name'])
      end

    end

    describe 'create_from_github(auth_hash)' do
      it "saves a user from build_from_github method" do
        test_auth_hash = {
          uid: 12345,
          "info" => {
            "email" => "joke@joke.com",
            "name" => "Faker"
          }
        }

        expect {
          new_user = User.create_from_github(test_auth_hash)
        }.must_change 'User.count', 1

        expect(User.last.uid.must_equal test_auth_hash[:uid])
        expect(User.last.email.must_equal test_auth_hash['info']['email'])
        expect(User.last.name.must_equal test_auth_hash['info']['name'])
      end
    end

  end
end
