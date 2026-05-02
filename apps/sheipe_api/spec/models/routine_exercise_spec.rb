require 'rails_helper'

RSpec.describe RoutineExercise, type: :model do
  subject(:re) { build(:routine_exercise) }

  it 'is valid with valid attributes' do
    expect(re).to be_valid
  end

  it 'requires position' do
    re.position = nil
    expect(re).not_to be_valid
  end

  it 'belongs to routine and exercise' do
    expect(described_class.reflect_on_association(:routine).macro).to eq(:belongs_to)
    expect(described_class.reflect_on_association(:exercise).macro).to eq(:belongs_to)
  end

  it 'has many routine_sets' do
    expect(described_class.reflect_on_association(:routine_sets).macro).to eq(:has_many)
  end
end
