require "test_helper"

describe Order do
  let(:order) { Order.new }

  it "must be valid" do
    value(order).must_be :valid?
  end
end

describe "validations" do
  it "requires a status" do
  end

  it "only allows the three valid statuses"
  end

  it "rejects invalid statuses"
  end

  it "requires a name"
  end

  it "requires an email"
  end

  it "requires an address"
  end

  it "requires the presence of a cc_num"
  end

  it "only accepts integers for cc_num"
  end

  it "requires cc_num to contain 16 integers"
  end

  it "requires cvv number"
  end

  it "requires ccv to contain 3 to 4 integers"
  end

  it "requires an expiration date"
  end

  it "rejects expiration dates set in the past"
  end

  it "requires a zip code"
  end


end

  #
  #   STATUSES = %w(pending paid complete cancelled)
  #   has_many :orderitems
  #
  #   validates :status, presence: true, inclusion: { in: STATUSES }
  #   validates :name, presence: true
  #   validates :email, presence: true
  #   validates :address, presence: true
  #   validates :cc_num, presence: true, numericality: { only_integer: true }, length: { is: 16 }
  #   validates :cvv, presence: true, length: { in: 3..4 }
  #   validate :expiration_date_cannot_be_in_the_past
  #   validates :zip, presence: true
  #
  #   def expiration_date_cannot_be_in_the_past
  #    if exp_date.present? && exp_date < Date.today
  #      errors.add(:exp_date, 'can’t be in the past')
  #    end
  #   end
  # end
