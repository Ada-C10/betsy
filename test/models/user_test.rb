require "test_helper"

describe User do

  before do
    @linda = users(:one)
    @john = users(:two)
    @june = users(:june)
  end

  describe 'relations' do
    it "has a list of items" do
      expect(@linda).must_respond_to :items
      @linda.items.each do |item|
        expect(item).must_be_kind_of Item
      end
    end

    it "has a list of reviews" do
      expect(@linda).must_respond_to :reviews
      #NEED TO GIVE A YAML REVIEW
      @linda.must_respond_to :reviews
      @linda.reviews.each do |review|
        expect(review).must_be_kind_of Review
      end
    end
  end

  let(:dup_user_name_and_provider) {
    dup_user = User.create(nickname: "#{@linda.nickname}", provider: "#{@linda.provider}", email: "lisa@yahoo.com", uid: "000" )
    dup_user
  }

  let(:dup_user_name_only) {
    dup_user = User.create(nickname: "Liam", email: "liam@yahoo.com", uid: "001", provider: "whatever")
    dup_user.nickname = @john.nickname
    dup_user.provider = "not a dup provider"
    dup_user
  }

  let(:dup_user_provider_only) {
    dup_user = User.create(nickname: "Liam", email: "liam@yahoo.com", uid: "001", provider: "whatever")
    dup_user.email = "not a dup email"
    dup_user.provider = @john.provider
    dup_user
  }

  let(:dup_user_email_only) {
    dup_user = User.create(nickname: "bad email", email: "#{@john.email}", uid: "002", provider: "whatever1")
    dup_user
  }

  describe 'validations' do
    it 'will create a valid user' do
      expect(@linda.valid?).must_equal true
    end

    it 'wont create user with duplicate email' do

      starting_count = User.count

      dup_user = dup_user_email_only

      ending_count = User.count

      expect(ending_count).must_equal starting_count

      expect(@john.valid?).must_equal true
      expect(dup_user.valid?).must_equal false
      expect(dup_user.errors.messages).must_include :email
    end

    it 'will not create a user who has a duplicate username for the same provider as existing user' do

      starting_count = User.count

      dup_user = dup_user_name_and_provider

      ending_count = User.count

      expect(ending_count).must_equal starting_count

      expect(@linda.valid?).must_equal true
      expect(dup_user.valid?).must_equal false
      expect(dup_user.errors.messages).must_include :nickname
    end

    it 'will create a user who has a duplicate username but a different provider than existing user' do

      starting_count = User.count

      dup_user = dup_user_provider_only

      ending_count = User.count

      expect(ending_count).must_equal starting_count + 1

      expect(@john.valid?).must_equal true
      expect(dup_user.valid?).must_equal true
    end

    it 'will create a user who has a duplicate provider but a different email than existing user' do

      starting_count = User.count

      dup_user = dup_user_provider_only

      ending_count = User.count

      expect(ending_count).must_equal starting_count + 1

      expect(@john.valid?).must_equal true
      expect(dup_user.valid?).must_equal true
    end
  end

  let(:item_ids){
    items = Item.all
    item_ids = items.map { |item| item.user_id }
  }

  describe 'is_a_merchant?(given_ids)' do

    it 'will return true if user has more than one or more items / is a merchant' do

      #greater than or equal to 1
      expect(@linda.items.length).must_be :>=, 1
      expect(@linda.is_a_merchant?(item_ids)).must_equal true
    end

    it 'will return false if user has less than one item' do

      #less than 1
      expect(@june.items.length).must_be :<=, 1
      expect(@june.is_a_merchant?(item_ids)).must_equal false
    end
  end

end
