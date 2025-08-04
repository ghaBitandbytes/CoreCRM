class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :edit, :update]

  def index
    authorize Company
    @company = policy_scope(Company).order(created_at: :desc).first
    @activities = Companies::ActivityFetcher.new(@company).call
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
    authorize Company
    @company = Companies::CreateFromLeadService.new(params).call

    if @company.persisted?
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
