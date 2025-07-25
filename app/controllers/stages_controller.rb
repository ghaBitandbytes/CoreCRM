class StagesController < ApplicationController
  before_action :set_stage, only: [:edit, :update, :destroy]

  def index
    @stages = Stage.order(:position)
  end

  def new
    @stage = Stage.new
  end

  def create
    @stage = Stage.new(stage_params)
    if @stage.save
      redirect_to stages_path, notice: "Stage added successfully"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @stage.update(stage_params)
      redirect_to stages_path, notice: "Stage updated successfully"
    else
      render :edit
    end
  end

  def destroy
    @stage.destroy
    redirect_to stages_path, notice: "Stage deleted successfully"
  end

  private

  def set_stage
    @stage = Stage.find(params[:id])
  end

  def stage_params
    params.require(:stage).permit(:name, :position)
  end
end
