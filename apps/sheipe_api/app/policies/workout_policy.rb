class WorkoutPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    record.user_id == user.id
  end

  def create?
    user.present?
  end

  def update?
    record.user_id == user.id
  end

  def destroy?
    update?
  end

  def finish?
    update?
  end

  relation_scope do |relation|
    next relation.none unless user.present?
    relation.where(user_id: user.id)
  end
end
