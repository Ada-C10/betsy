require "test_helper"

describe Product do
  let(:product) { products(:kilimanjaro) }

  it "must be valid" do
    expect(product).must_be :valid?
  end
end

describe "validations" do
  it "requires a name" do
    product = products(:kilimanjaro)
    product.name = nil

    valid = product.save

    expect(valid).must_equal false
    expect(product.errors.messages).must_include :name
    expect(product.errors.messages[:name]).must_equal ["Cannot be blank"]
  end

  it "requires a unique name" do
    other_product = products(:kilimanjaro)
    other_product.name = product.name

    valid = other_product.valid?

    expect(valid).must_equal false
    expect(other_product.errors.messages).must_include :name
  end


  it "requires a cost" do
    product = products(:kilimanjaro)
    product.cost = 3000.0

    valid = product.save

    expect(valid).must_equal true
  end

  it "cost must be greater than zero"
    product = products(:kilimanjaro)
    product.cost = 3000.0

    valid = product.save

    expect(valid).must_equal :>=, 0
    expect(valid).must_be_instance_of Integer
  end

  it "cost must accept a value of nil"
    product = products(:kilimanjaro)
    product.cost = nil

    valid = product.save

    expect(valid).must_equal true
  end


  it "requires a inventory" do
    product = products(:safari)
    product.inventory = nil

    valid = product.save

    expect(valid).must_equal false
    expect(product.errors.messages).must_include :inventory
    expect(product.errors.messages[:inventory]).must_equal ["Cannot be blank"]
  end

  it "inventory must be an integer" do
    product = products(:kilimanjaro)
    product.inventory = 10

    valid = product.save

    expect(valid).must_equal true
    expect(valid).must_be_instance_of Integer
  end

  it "requires a description" do
  end

  it "active status can only be true or false" do
  end

  it "requires a image" do
  end

#Sammi Joo
# describe Product do
#   let(:product) { Product.new }
#
#   describe "relations" do
#     it "has a list of votes" do
#        album = works(:album)
#        album.must_respond_to :votes
#        album.votes.each do |vote|
#          vote.must_be_kind_of Vote
#        end
#     end
#
#     it "has a list of voting users" do
#       album = works(:album)
#       album.must_respond_to :ranking_users
#       album.ranking_users.each do |user|
#         user.must_be_kind_of User
#       end
#     end
#   end
#
#   describe "relations" do
#     it "has a user" do
#       v = votes(:one)
#       v.must_respond_to :user
#       v.user.must_be_kind_of User
#     end
#
#     it "has a work" do
#       v = votes(:one)
#       v.must_respond_to :work
#       v.work.must_be_kind_of Work
#     end
#   end
#
#   describe "relations" do
#     it "has a list of votes" do
#       dan = users(:dan)
#       dan.must_respond_to :votes
#       dan.votes.each do |vote|
#         vote.must_be_kind_of Vote
#       end
#     end
#
#     it "has a list of ranked works" do
#       dan = users(:dan)
#       dan.must_respond_to :ranked_works
#       dan.ranked_works.each do |work|
#         work.must_be_kind_of Work
#       end
#     end
#   end
# end
#
