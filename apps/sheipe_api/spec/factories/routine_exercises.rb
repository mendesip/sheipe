FactoryBot.define do
  factory :routine_exercise do
    association :routine
    association :exercise
    sequence(:position) { |n| n }
    notes { "" }
  end
end
