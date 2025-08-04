class Users::RegistrationsController < Devise::RegistrationsController
  include RoleRedirectHelper

  def after_sign_up_path_for(resource)
    path_for_role(resource)
  end
end
