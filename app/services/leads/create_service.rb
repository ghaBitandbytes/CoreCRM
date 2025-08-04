module Leads
  class CreateService
    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      lead = @user.leads.build(lead_attributes)
      lead.company = Company.find_by(name: @params[:lead][:company])
      lead
    end

    private

    def lead_attributes
      @params.require(:lead).permit(:name, :email, :phone, :company_id, :source, :status, :tags, :notes, :assigned_to)
    end
  end
end
