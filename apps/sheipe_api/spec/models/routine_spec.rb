require 'rails_helper'

RSpec.describe Routine, type: :model do
  subject(:routine) { build(:routine) }

  it 'is valid with valid attributes' do
    expect(routine).to be_valid
  end

  it 'is invalid with blank name' do
    routine.name = ''
    expect(routine).not_to be_valid
    expect(routine.errors[:name]).to include("can't be blank")
  end

  it 'requires a creator' do
    routine.creator = nil
    expect(routine).not_to be_valid
  end

  it 'defaults is_template to false' do
    expect(Routine.new.is_template).to be(false)
  end

  it 'has many routine_exercises' do
    expect(described_class.reflect_on_association(:routine_exercises).macro).to eq(:has_many)
  end
end
