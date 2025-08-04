module Companies
  class CreateFromLeadService
    def initialize(params)
      @params = params
    end

    def call
      company = Company.new(company_attributes)
      lead = Lead.find_by(id: @params[:lead_id])

      company.lead = lead if lead.present?

      if company.save
        create_primary_contact(company, lead) if lead.present?
      end

      company
    end

    private

    def company_attributes
      @params.require(:company).permit(:name, :email, :phone, :website, :industry, :address, :lead_id)
    end

    def create_primary_contact(company, lead)
      Contact.create!(
        name: lead.name,
        email: lead.email,
        phone: lead.phone,
        title: "Primary Contact",
        company: company
      )
    end
  end
end
