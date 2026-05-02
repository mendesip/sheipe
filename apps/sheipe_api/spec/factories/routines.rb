FactoryBot.define do
  factory :routine do
    sequence(:name) { |n| "Routine #{n}" }
    description { "Description" }
    is_template { false }
    association :creator, factory: :user
  end
end
