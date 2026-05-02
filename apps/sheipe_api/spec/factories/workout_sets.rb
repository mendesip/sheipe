FactoryBot.define do
  factory :workout_set do
    association :workout_exercise
    sequence(:set_number) { |n| n }
    weight { 100.0 }
    reps { 5 }
    rpe { 8.0 }
    completed { true }
    notes { nil }
  end
end
