FactoryBot.define do
  factory :donation do
    amount_cents { 100 }
    association :user
    association :project
  end
end
