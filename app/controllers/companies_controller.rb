class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :edit, :update]

 def index
 
  @company = Company.order(created_at: :desc).first

  if @company.present?
    # Fetch activities for this company and its associated records
    @activities = PublicActivity::Activity
                  .where(
                    "(trackable_type = 'Company' AND trackable_id = :company_id) OR " +
                    "(trackable_type = 'Contact' AND recipient_id = :company_id AND recipient_type = 'Company') OR " +
                    "(trackable_type = 'Deal' AND recipient_id = :company_id AND recipient_type = 'Company') OR " +
                    "(trackable_type = 'Task' AND trackable_id IN (:task_ids))",
                    company_id: @company.id,
                    task_ids: @company.tasks.pluck(:id)
                  )
                  .order(created_at: :desc)
                  .limit(10)
  else
    @activities = []
  end
end

def export_pdf
  @company = Company.find(params[:id])
  @contacts = @company.contacts
  @deals = @company.deals

  respond_to do |format|
    format.pdf do
      render pdf: "company_#{@company.id}_details",
             template: "companies/export_pdf",
             layout: "pdf"
    end
  end
end

  def show
    @company = Company.find(params[:id])
    @contacts = @company.contacts
  end

  def all
    @companies = Company.all
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)

    # Assign lead before saving the company
    lead = Lead.find_by(id: params[:lead_id])
    @company.lead = lead if lead.present?

    if @company.save
      # Create contact from lead
      if lead.present?
        Contact.create!(
          name: lead.name,
          email: lead.email,
          phone: lead.phone,
          title: "Primary Contact",
          company: @company
        )
      end

      redirect_to companies_path, notice: "Company and primary contact created successfully."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @company.update(company_params)
      redirect_to @company, notice: "Company updated successfully."
    else
      render :edit
    end
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :email, :phone, :website, :industry, :address)
  end
end
