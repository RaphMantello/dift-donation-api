FactoryBot.define do
  factory :donation do
    amount_cents { 100 }
    currency { 'EUR' }
    association :user
    association :project
  end
end
