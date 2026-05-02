FactoryBot.define do
  factory :workout_exercise do
    association :workout
    association :exercise
    sequence(:position) { |n| n }
    notes { "" }
  end
end
