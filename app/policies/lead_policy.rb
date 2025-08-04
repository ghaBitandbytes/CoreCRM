class LeadPolicy < ApplicationPolicy
  def index?
    allowed_roles?("admin", "salesmanager", "sales")
  end

  def show?
    allowed_roles?("admin", "salesmanager", "sales")
  end

  def create?
    allowed_roles?("admin", "salesmanager", "sales")
  end

  def update?
    return true if allowed_roles?("admin", "salesmanager")
    return true if allowed_roles?("sales") && owns_record?
    false
  end

  def destroy?
    allowed_roles?("admin", "salesmanager")
  end

  def export?
    allowed_roles?("admin", "salesmanager", "sales")
  end

  def kanban?
    allowed_roles?("admin", "salesmanager", "sales")
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if allowed_roles?("admin", "salesmanager")
        scope.all
      elsif allowed_roles?("sales")
        scope.where(user_id: user.id)
      else
        scope.none
      end
    end

    private

    def allowed_roles?(*roles)
      roles.flatten.include?(user.role)
    end
  end

  private

  def allowed_roles?(*roles)
    roles.flatten.include?(user.role)
  end

  def owns_record?
    record.user_id == user.id
  end
end
