FactoryBot.define do
  factory :workout do
    association :user
    started_at { Time.current }
    finished_at { nil }
    notes { nil }
  end
end
