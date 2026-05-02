require 'rails_helper'

RSpec.describe ExercisePolicy do
  let(:owner) { create(:user) }
  let(:other) { create(:user) }
  let(:admin) { create(:user).tap { |u| u.update_column(:role, User.roles[:admin]) } }

  let(:system_exercise) { create(:exercise, :system) }
  let(:owned_exercise)  { create(:exercise, creator: owner) }

  describe "#index?" do
    it "permits authenticated user" do
      expect(described_class.new(nil, user: owner).apply(:index?)).to be(true)
    end
  end

  describe "#show?" do
    it "permits any user to view system exercise" do
      expect(described_class.new(system_exercise, user: other).apply(:show?)).to be(true)
    end

    it "permits owner to view own exercise" do
      expect(described_class.new(owned_exercise, user: owner).apply(:show?)).to be(true)
    end

    it "denies non-owner viewing another user's custom exercise" do
      expect(described_class.new(owned_exercise, user: other).apply(:show?)).to be(false)
    end
  end

  describe "#create?" do
    it "permits any authenticated user" do
      expect(described_class.new(Exercise.new, user: owner).apply(:create?)).to be(true)
    end
  end

  describe "#update?" do
    it "permits owner" do
      expect(described_class.new(owned_exercise, user: owner).apply(:update?)).to be(true)
    end

    it "denies non-owner" do
      expect(described_class.new(owned_exercise, user: other).apply(:update?)).to be(false)
    end

    it "denies non-admin updating system exercise" do
      expect(described_class.new(system_exercise, user: owner).apply(:update?)).to be(false)
    end

    it "permits admin to update system exercise" do
      expect(described_class.new(system_exercise, user: admin).apply(:update?)).to be(true)
    end

    it "permits admin to update any custom exercise" do
      expect(described_class.new(owned_exercise, user: admin).apply(:update?)).to be(true)
    end
  end

  describe "#destroy?" do
    it "follows update? rules" do
      expect(described_class.new(owned_exercise, user: owner).apply(:destroy?)).to be(true)
      expect(described_class.new(owned_exercise, user: other).apply(:destroy?)).to be(false)
      expect(described_class.new(system_exercise, user: owner).apply(:destroy?)).to be(false)
      expect(described_class.new(system_exercise, user: admin).apply(:destroy?)).to be(true)
    end
  end

  describe "relation scope" do
    it "returns system exercises plus user's own" do
      system_exercise
      owned_exercise
      others = create(:exercise, creator: other)

      scoped = described_class.new(nil, user: owner).apply_scope(Exercise.all, type: :active_record_relation)
      expect(scoped).to include(system_exercise, owned_exercise)
      expect(scoped).not_to include(others)
    end
  end
end
