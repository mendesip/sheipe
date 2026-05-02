require 'rails_helper'

RSpec.describe RoutinePolicy do
  let(:owner) { create(:user) }
  let(:other) { create(:user) }
  let(:routine) { create(:routine, creator: owner) }

  it "permits owner to show/update/destroy" do
    %i[show? update? destroy?].each do |action|
      expect(described_class.new(routine, user: owner).apply(action)).to be(true)
    end
  end

  it "denies non-owner show/update/destroy" do
    %i[show? update? destroy?].each do |action|
      expect(described_class.new(routine, user: other).apply(action)).to be(false)
    end
  end

  it "permits any authenticated user to index/create" do
    expect(described_class.new(nil, user: other).apply(:index?)).to be(true)
    expect(described_class.new(Routine.new, user: other).apply(:create?)).to be(true)
  end

  it "scope returns only the user's own routines" do
    routine
    other_routine = create(:routine, creator: other)
    scoped = described_class.new(nil, user: owner).apply_scope(Routine.all, type: :active_record_relation)
    expect(scoped).to include(routine)
    expect(scoped).not_to include(other_routine)
  end
end
