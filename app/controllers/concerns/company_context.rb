module CompanyContext
  extend ActiveSupport::Concern

  included do
    before_action :set_company
  end

  private

  def set_company
    @company = params[:company_id] ? Company.find(params[:company_id]) : @deal&.company
  end
end
