require 'rails_helper'

RSpec.describe WorkoutPolicy do
  let(:owner) { create(:user) }
  let(:other) { create(:user) }
  let(:workout) { create(:workout, user: owner) }

  it "permits owner to show/update/destroy/finish" do
    %i[show? update? destroy? finish?].each do |action|
      expect(described_class.new(workout, user: owner).apply(action)).to be(true)
    end
  end

  it "denies non-owner" do
    %i[show? update? destroy? finish?].each do |action|
      expect(described_class.new(workout, user: other).apply(action)).to be(false)
    end
  end

  it "scope returns only own workouts" do
    workout
    foreign = create(:workout, user: other)
    scoped = described_class.new(nil, user: owner).apply_scope(Workout.all, type: :active_record_relation)
    expect(scoped).to include(workout)
    expect(scoped).not_to include(foreign)
  end
end
