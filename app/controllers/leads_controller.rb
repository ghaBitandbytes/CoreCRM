class LeadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lead, only: %i[show edit update destroy]

  def index
   @leads = accessible_leads

    if params[:query].present?
      q = "%#{params[:query]}%"
      @leads = @leads.where(
        "name ILIKE :q OR source ILIKE :q OR status ILIKE :q",
        q: q
      )
    end
  end

  def export
    @leads = accessible_leads

    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"leads-#{Date.today}.csv\""
        headers['Content-Type'] ||= 'text/csv'
        render csv: @leads
      end
    end
  end

  def show; end

  def new
    @lead = current_user.leads.build
  end

  def kanban
    @leads = accessible_leads

    @new_leads        = @leads.where(status: 'New')
  @contacted_leads  = @leads.where(status: 'Contacted')
  @converted_leads  = @leads.where(status: 'Converted')
  @lost_leads       = @leads.where(status: 'Lost')
  @qualified_leads  = @leads.where(status: 'Qualified') if current_user.role == 'salesmanager'

  @statuses = ['New', 'Contacted', 'Converted', 'Lost']
  @statuses << 'Qualified' if current_user.role == 'salesmanager'
  @leads_by_status = Lead.where(status: @statuses).group_by(&:status)
end


def create
  @lead = current_user.leads.build(lead_params)
  @lead.company = Company.find_by(name: params[:lead][:company])

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


  def edit; end

  def update
  @lead = Lead.find(params[:id])

  if @lead.update(lead_params)
    if @lead.status == "Qualified" && current_user.role == "salesmanager"
      flash[:qualified_lead_id] = @lead.id
      redirect_to salesmanager_dashboard_path, notice: "Lead qualified successfully."
    else
      redirect_to @lead, notice: "Lead updated successfully."
    end
  else
    render :edit
  end
end




  def destroy
    @lead.destroy
    redirect_to leads_path, notice: "Lead deleted successfully."
  end

  private

  def accessible_leads
    if current_user.role.in?(%w[salesmanager admin])
      Lead.all
    else
      current_user.leads
    end
  end

  def set_lead
    @lead = accessible_leads.find(params[:id])
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
