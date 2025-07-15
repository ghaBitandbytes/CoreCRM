class ReminderMailer < ApplicationMailer
  default from: 'ghaziah053@gmail.com'
  def send_reminder(reminder)
    @reminder = reminder
    @user = reminder.user
    @lead = reminder.lead

    mail(to: @user.email, subject: "Reminder: #{@reminder.title}")
  end
end
