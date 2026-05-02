require 'rails_helper'

RSpec.describe WorkoutExercise, type: :model do
  subject(:we) { build(:workout_exercise) }

  it 'is valid with valid attributes' do
    expect(we).to be_valid
  end

  it 'requires position' do
    we.position = nil
    expect(we).not_to be_valid
  end

  it 'allows nil routine_exercise (free workout)' do
    we.routine_exercise = nil
    expect(we).to be_valid
  end

  it 'has many workout_sets' do
    expect(described_class.reflect_on_association(:workout_sets).macro).to eq(:has_many)
  end
end
