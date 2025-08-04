class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :edit, :update]

  def index
    authorize Company
    @company = policy_scope(Company).order(created_at: :desc).first

    if @company.present?
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
    authorize @company

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
    authorize @company
    @contacts = @company.contacts
  end

  def all
    @companies = policy_scope(Company)
    authorize Company
  end

  def new
    @company = Company.new
    authorize @company
  end

  def create
    @company = Company.new(company_params)
    authorize @company

    lead = Lead.find_by(id: params[:lead_id])
    @company.lead = lead if lead.present?

    if @company.save
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

  def edit
    authorize @company
  end

  def update
    authorize @company
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
    params.require(:company).permit(:name, :email, :phone, :website, :industry, :address, :lead_id)
  end
end
