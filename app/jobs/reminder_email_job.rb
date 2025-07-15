class ReminderEmailJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform
    reminders = Reminder.where("remind_at <= ?", Time.current)
    Rails.logger.info "Sending #{reminders.count} reminders..."
    reminders.each do |reminder|
      ReminderMailer.send_reminder(reminder).deliver_now
    end
  end
end
