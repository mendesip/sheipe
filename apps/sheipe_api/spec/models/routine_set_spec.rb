require 'rails_helper'

RSpec.describe RoutineSet, type: :model do
  subject(:rs) { build(:routine_set) }

  it 'is valid with valid attributes' do
    expect(rs).to be_valid
  end

  it 'requires set_number' do
    rs.set_number = nil
    expect(rs).not_to be_valid
  end

  it 'requires set_type' do
    rs.set_type = nil
    expect(rs).not_to be_valid
  end

  it 'rejects invalid set_type' do
    expect { rs.set_type = "bogus" }.to raise_error(ArgumentError)
  end

  it 'accepts each valid set_type' do
    %w[warmup working drop_set failure].each do |type|
      rs.set_type = type
      expect(rs).to be_valid, "expected #{type} to be valid"
    end
  end
end
