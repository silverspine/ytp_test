FactoryBot.define do
  factory :movement do
    amount { Faker::Number.decimal(2) }
    reference { Faker::Alphanumeric.unique.alpha 22 }
    account_id { nil }
  end
end
