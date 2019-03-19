FactoryBot.define do
  factory :account do
    CLABE { Faker::Alphanumeric.unique.alpha 18 }
    user_id { nil }
  end
end
