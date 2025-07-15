class DealsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_salesmanager!
  before_action :set_company, except: [:kanban, :update_stage]
  before_action :set_deal, only: [:show, :edit, :update, :destroy]

  def index
    if params[:company_id]
      @company = Company.find(params[:company_id])
      @deals = @company.deals
    else
      @deals = current_user.deals
      @show_all_deals = true
    end
  end

  def new
    @deal = @company.deals.build(user: current_user)
  end

  def create
  @deal = @company.deals.build(deal_params)
  @deal.user = current_user
  @deal.entered_stage_at ||= Time.current

  if @deal.save
    @deal.create_activity key: 'deal.created', 
                         owner: current_user, 
                         recipient: @company
    redirect_to company_deals_path(@company), notice: "Deal was successfully created."
  else
    render :new
  end
end

  def show
    @deal_tasks = @deal.tasks 
  end

  def edit; end

  def kanban
    @stages = Stage.order(:position)
    @deals = if params[:company_id]
               @company = Company.find(params[:company_id])
               @company.deals.where(user: current_user).includes(:stage, :company)
             else
               current_user.deals.includes(:stage, :company)
             end
  end

  def update_stage
    @deal = Deal.find(params[:id])
    if @deal.update(stage_id: params[:stage_id])
      head :ok
    else
      render json: { errors: @deal.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @deal.destroy
    redirect_to company_deals_path(@company), notice: "Deal was successfully deleted."
  end

  private

  def authorize_salesmanager!
    redirect_to root_path, alert: "Access denied." unless current_user.salesmanager?
  end

  def set_company
    @company = params[:company_id] ? Company.find(params[:company_id]) : @deal&.company
  end

  def set_deal
    @deal = if params[:company_id]
              current_user.deals.where(company_id: params[:company_id]).find(params[:id])
            else
              current_user.deals.find(params[:id])
            end
  rescue ActiveRecord::RecordNotFound
    redirect_to(
      params[:company_id] ? company_deals_path : deals_path,
      alert: "Deal not found or you don't have access"
    )
  end

  def deal_params
    params.require(:deal).permit(:title, :value, :probability, :close_date, :stage_id, :contact_id)
  end
end
