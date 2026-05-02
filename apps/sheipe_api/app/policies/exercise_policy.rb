class ExercisePolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    return false unless user.present?
    record.is_system? || record.creator_id == user.id
  end

  def create?
    user.present?
  end

  def update?
    return false unless user.present?
    return false if record.is_system? && !user.admin?
    record.creator_id == user.id || user.admin?
  end

  def destroy?
    update?
  end

  relation_scope do |relation|
    next relation.none unless user.present?
    relation.where("is_system = TRUE OR creator_id = ?", user.id)
  end
end
