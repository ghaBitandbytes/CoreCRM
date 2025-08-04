module Leads
  class UpdateService
    def initialize(lead, user, params)
      @lead = lead
      @user = user
      @params = params
    end

    def call
      previous_status = @lead.status
      updated = @lead.update(lead_params)

      if updated && qualified_by_salesmanager?(previous_status)
        @lead.update(converted_at: Time.current)
        return :qualified
      elsif @params[:lead].key?(:notes)
        return :notes_updated
      elsif updated
        return :updated
      end

      :failed
    end

    private

    def lead_params
      @params.require(:lead).permit(:name, :email, :phone, :company_id, :source, :status, :tags, :notes, :assigned_to)
    end

    def qualified_by_salesmanager?(previous_status)
      @lead.status == "Qualified" && @user.role == "salesmanager" && previous_status != "Qualified"
    end
  end
end
