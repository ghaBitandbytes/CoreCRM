class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_taskable
  before_action :set_task, only: [:edit, :update, :destroy]

  def new
    @task = @taskable.tasks.new
  end

  def create
    @task = Tasks::CreateService.new(current_user, @taskable, task_params).call

    if @task.persisted?
      redirect_to after_task_path, notice: "Task created."
    else
      render :new
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to after_task_path, notice: "Task updated."
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path, notice: "Task deleted." }
    end
  end

  private

  def set_taskable
    return unless params[:deal_id] || params[:contact_id] || params[:company_id]

    klass = [Deal, Contact, Company].find { |c| params["#{c.name.underscore}_id"].present? }
    @taskable = klass.find(params["#{klass.name.underscore}_id"]) if klass
  end

  def set_task
    @task = @taskable.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :due_date, :status)
  end

  def after_task_path
    @taskable.is_a?(Deal) ? deal_path(@taskable) : request.referer || root_path
  end
end
