FactoryBot.define do
  factory :exercise do
    sequence(:name) { |n| "Exercise #{n}" }
    description { "Description" }
    muscle_group { "chest" }
    category { "strength" }
    is_system { false }
    association :creator, factory: :user

    trait :system do
      is_system { true }
      creator { nil }
    end
  end
end
