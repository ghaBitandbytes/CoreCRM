class RemindersController < ApplicationController
  def create
    @lead = Lead.find(params[:lead_id])

    @reminder = Reminders::CreateService.new(
      lead: @lead,
      user: current_user,
      params: reminder_params
    ).call

    if @reminder.persisted?
      redirect_to lead_path(@lead), notice: "Reminder added."
    else
      render "leads/show", status: :unprocessable_entity
    end
  end

  private

  def reminder_params
    params.require(:reminder).permit(:title, :notes, :remind_at, :status)
  end
end
