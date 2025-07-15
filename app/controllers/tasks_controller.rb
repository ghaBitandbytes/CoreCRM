class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_taskable
  before_action :set_task, only: [:edit, :update, :destroy]

  def new
    @task = @taskable.tasks.new
  end

  # app/controllers/tasks_controller.rb
def create
  @task = @taskable.tasks.new(task_params)
  @task.user = current_user

  if @task.save
    # Set activity recipient explicitly to the company if taskable is a Company
    if @taskable.is_a?(Company)
@task.create_activity(
  key: 'task.created',
  owner: current_user,
  recipient: @taskable,
  parameters: {
    title: @task.title,
    due_date: @task.due_date,
    status: @task.status
  }
)
    end

    if @taskable.is_a?(Deal)
      redirect_to deal_path(@taskable), notice: "Task created."
    else
      redirect_back fallback_location: root_path, notice: "Task created."
    end
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
    if @taskable.is_a?(Deal)
      redirect_to deal_path(@taskable), notice: "Task updated."
    else
      redirect_back fallback_location: root_path, notice: "Task updated."
    end
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
  # Only set taskable if we're coming from a nested route
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
end
