FactoryBot.define do
  factory :routine_set do
    association :routine_exercise
    sequence(:set_number) { |n| n }
    weight { 80.0 }
    reps { 8 }
    rest_seconds { 90 }
    set_type { "working" }
  end
end
