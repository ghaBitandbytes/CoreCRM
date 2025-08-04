class DealsController < ApplicationController
  include CompanyContext

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
    @deal = Deals::CreateService.new(@company, current_user, params).call

    if @deal.persisted?
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
    stage = Stage.find(params[:stage_id])

    if Deals::StageUpdateService.new(@deal, stage).call
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
end
