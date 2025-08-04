class CompanyPolicy < ApplicationPolicy
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
    allowed_roles?("admin", "salesmanager")
  end

  def destroy?
    allowed_roles?("admin", "salesmanager")
  end

  def export_pdf?
    allowed_roles?("admin", "salesmanager")
  end

  def all?
  allowed_roles?("admin", "salesmanager")
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
