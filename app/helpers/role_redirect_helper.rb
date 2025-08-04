module RoleRedirectHelper
  def path_for_role(user)
    case user.role
    when 'sales'
      leads_path
    when 'salesmanager'
      salesmanager_dashboard_path
    else
      root_path
    end
  end
end
