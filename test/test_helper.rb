ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/reporters"  # for Colorized output
#  For colorful output!
Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)


# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...



  def setup
    OmniAuth.config.test_mode = true
  end

  def mock_merch_hash(merchant)
    return {
      provider: merchant.provider,
      uid: merchant.uid,
      info: {
        name: merchant.name,
        email: merchant.email
      }
    }
  end

  def perform_login(merchant)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_merch_hash(merchant))
    get merchant_callback_path(:github)
  end

end
