require 'csv'

class LeadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lead, only: %i[show edit update destroy]

  def index
    @leads = policy_scope(Lead)
    @hot_leads_count = @leads.where(status: 'Qualified').count

    if params[:query].present?
      q = "%#{params[:query]}%"
      @leads = @leads.where("name ILIKE :q OR source ILIKE :q OR status ILIKE :q", q: q)
    end

    if params[:status].present?
      filter_key = params[:status].to_s.downcase.strip

      filter_map = {
        'hot' => 'Qualified',
        'new' => 'New'
      }

      if filter_map.key?(filter_key)
        @leads = @leads.where("LOWER(status) = ?", filter_map[filter_key].downcase)
      elsif filter_key != 'all'
        @leads = @leads.none
      end
    end
  end

  def export
    @leads = policy_scope(Lead)
    authorize Lead

    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"leads-#{Date.today}.csv\""
        headers['Content-Type'] ||= 'text/csv'
        render csv: @leads
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
    @lead = current_user.leads.build(lead_params)
    @lead.company = Company.find_by(name: params[:lead][:company])
    authorize @lead

    if @lead.save
      if current_user.role == "salesmanager"
        redirect_to salesmanager_dashboard_path
      else
        redirect_to @lead
      end
    else
      render :new
    end
  end

  def edit
    authorize @lead
  end

  def update
    authorize @lead
    previous_status = @lead.status

    if @lead.update(lead_params)
      if @lead.status == "Qualified" && current_user.role == "salesmanager"
        @lead.update(converted_at: Time.current) unless previous_status == "Qualified"
        flash[:qualified_lead_id] = @lead.id
        redirect_to salesmanager_dashboard_path, notice: "Lead qualified and timestamped."

      elsif params[:lead].key?(:notes)
        redirect_to kanban_leads_path

      else
        redirect_to @lead, notice: "Lead updated successfully."
      end
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

    @new_leads        = @leads.where(status: 'New')
    @contacted_leads  = @leads.where(status: 'Contacted')
    @converted_leads  = @leads.where(status: 'Converted')
    @lost_leads       = @leads.where(status: 'Lost')
    @qualified_leads  = @leads.where(status: 'Qualified') if current_user.role == 'salesmanager'

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

  def lead_params
    params.require(:lead).permit(
      :name, :email, :phone, :company_id, :source, :status,
      :tags, :notes, :assigned_to
    )
  end
end
