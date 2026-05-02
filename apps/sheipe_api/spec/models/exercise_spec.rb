require 'rails_helper'

RSpec.describe Exercise, type: :model do
  subject(:exercise) { build(:exercise) }

  it 'is valid with valid attributes' do
    expect(exercise).to be_valid
  end

  it 'is invalid with blank name' do
    exercise.name = ''
    expect(exercise).not_to be_valid
    expect(exercise.errors[:name]).to include("can't be blank")
  end

  it 'rejects invalid muscle_group' do
    expect { exercise.muscle_group = 'fingers' }.to raise_error(ArgumentError)
  end

  it 'accepts each valid muscle_group' do
    %w[chest back shoulders biceps triceps legs glutes core full_body].each do |group|
      exercise.muscle_group = group
      expect(exercise).to be_valid, "expected #{group} to be valid"
    end
  end

  it 'rejects invalid category' do
    expect { exercise.category = 'plyometrics' }.to raise_error(ArgumentError)
  end

  it 'accepts each valid category' do
    %w[strength cardio mobility].each do |category|
      exercise.category = category
      expect(exercise).to be_valid, "expected #{category} to be valid"
    end
  end

  it 'defaults is_system to false' do
    expect(Exercise.new.is_system).to be(false)
  end

  it 'allows nil creator (system exercise)' do
    exercise = build(:exercise, :system)
    expect(exercise.creator).to be_nil
    expect(exercise.is_system).to be(true)
    expect(exercise).to be_valid
  end

  it 'belongs to a creator user when present' do
    user = create(:user)
    exercise = create(:exercise, creator: user)
    expect(exercise.creator).to eq(user)
  end
end
