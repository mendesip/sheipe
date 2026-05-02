require 'rails_helper'

RSpec.describe WorkoutSet, type: :model do
  subject(:ws) { build(:workout_set) }

  it 'is valid with valid attributes' do
    expect(ws).to be_valid
  end

  it 'requires set_number' do
    ws.set_number = nil
    expect(ws).not_to be_valid
  end

  it 'rejects rpe greater than 10' do
    ws.rpe = 11
    expect(ws).not_to be_valid
    expect(ws.errors[:rpe]).to be_present
  end

  it 'rejects rpe less than 1' do
    ws.rpe = 0.5
    expect(ws).not_to be_valid
  end

  it 'allows nil rpe' do
    ws.rpe = nil
    expect(ws).to be_valid
  end

  it 'defaults completed to false' do
    expect(WorkoutSet.new.completed).to be(false)
  end
end
