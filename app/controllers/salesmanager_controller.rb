class SalesmanagerController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_salesmanager!

  def index
     @leads = Lead.includes(:user).order(created_at: :desc)
  end

  private

  def ensure_salesmanager!
    unless current_user.salesmanager?
      redirect_to root_path, alert: "Access denied. Only Sales Managers allowed."
    end
  end
end
