FactoryBot.define do
  factory :order do
    status { %w(pending paid complete cancelled).sample}
    cust_name { Faker::RuPaul.queen}
    cust_email { Faker::Internet.safe_email}
    mailing_address { Faker::Address.full_address}
    cc_name { Faker::FunnyName.two_word_name}
    cc_digit { "1" * 16}
    cc_expiration { Faker::Business.credit_card_expiry_date}
    cc_cvv { Faker::Number.number(3) }
    cc_zip { Faker::Number.number(5) }
  end
end
