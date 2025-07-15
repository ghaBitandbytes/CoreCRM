class RemindersController < ApplicationController
  def create
    @lead = Lead.find(params[:lead_id])
    @reminder = @lead.reminders.build(reminder_params)
    @reminder.user = current_user

    if @reminder.save
      redirect_to lead_path(@lead), notice: "Reminder added."
    else
      render "leads/show", status: :unprocessable_entity
    end
  end

  private

  def reminder_params
    params.require(:reminder).permit(:title, :notes, :remind_at, :status, :user_id)
  end
end
