require 'rails_helper'

RSpec.describe Workout, type: :model do
  subject(:workout) { build(:workout) }

  it 'is valid with valid attributes' do
    expect(workout).to be_valid
  end

  it 'requires user' do
    workout.user = nil
    expect(workout).not_to be_valid
  end

  it 'allows nil routine (free workout)' do
    workout.routine = nil
    expect(workout).to be_valid
  end

  it 'allows nil finished_at (in-progress)' do
    workout.finished_at = nil
    expect(workout).to be_valid
  end

  it 'has many workout_exercises' do
    expect(described_class.reflect_on_association(:workout_exercises).macro).to eq(:has_many)
  end

  describe ".finished" do
    it "returns only workouts with finished_at set" do
      done = create(:workout, finished_at: Time.current)
      _wip = create(:workout, finished_at: nil)
      expect(Workout.finished).to include(done)
      expect(Workout.finished.where(finished_at: nil)).to be_empty
    end
  end
end
