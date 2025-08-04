class LeadsController < ApplicationController
  include LeadFilterable

  before_action :authenticate_user!
  before_action :set_lead, only: %i[show edit update destroy]

  def index
    @leads = filter_leads(policy_scope(Lead))
    @hot_leads_count = @leads.where(status: 'Qualified').count
  end

  def export
    @leads = policy_scope(Lead)
    authorize Lead

    respond_to do |format|
      format.csv do
        send_data Leads::ExportService.to_csv(@leads),
                  filename: "leads-#{Date.today}.csv",
                  type: "text/csv"
      end
    end
  end

  def show
    authorize @lead
  end

  def new
    @lead = current_user.leads.build
    authorize @lead
  end

  def create
    @lead = Leads::CreateService.new(current_user, params).call
    authorize @lead

    if @lead.save
      redirect_to current_user.role == "salesmanager" ? salesmanager_dashboard_path : @lead
    else
      render :new
    end
  end

  def edit
    authorize @lead
  end

  def update
    authorize @lead
    result = Leads::UpdateService.new(@lead, current_user, params).call

    case result
    when :qualified
      flash[:qualified_lead_id] = @lead.id
      redirect_to salesmanager_dashboard_path, notice: "Lead qualified and timestamped."
    when :notes_updated
      redirect_to kanban_leads_path
    when :updated
      redirect_to @lead, notice: "Lead updated successfully."
    else
      render :edit
    end
  end

  def destroy
    authorize @lead
    @lead.destroy
    redirect_to leads_path, notice: "Lead deleted successfully."
  end

  def kanban
    @leads = policy_scope(Lead)
    authorize Lead, :index?

    @statuses = ['New', 'Contacted', 'Converted', 'Lost']
    @statuses << 'Qualified' if current_user.role == 'salesmanager'

    @leads_by_status = @leads.where(status: @statuses).group_by(&:status)
  end

  private

  def set_lead
    @lead = policy_scope(Lead).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to leads_path, alert: "Lead not found or you are not authorized to access it."
  end
end
