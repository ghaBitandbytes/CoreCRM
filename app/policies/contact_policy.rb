class ContactPolicy < ApplicationPolicy
  def index?
    allowed_roles?("admin", "salesmanager")
  end

  def show?
    allowed_roles?("admin", "salesmanager")
  end

  def create?
    allowed_roles?("admin", "salesmanager")
  end

  def update?
    user.admin? || user.salesmanager?
  end

  def destroy?
    user.admin? || user.salesmanager?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if allowed_roles?("admin", "salesmanager")
        scope.all
      else
        scope.none
      end
    end

    private

    def allowed_roles?(*roles)
      roles.include?(user.role)
    end
  end

  private

  def allowed_roles?(*roles)
    roles.include?(user.role)
  end
end
