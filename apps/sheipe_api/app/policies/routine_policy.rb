class RoutinePolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    record.creator_id == user.id
  end

  def create?
    user.present?
  end

  def update?
    record.creator_id == user.id
  end

  def destroy?
    update?
  end

  relation_scope do |relation|
    next relation.none unless user.present?
    relation.where(creator_id: user.id)
  end
end
