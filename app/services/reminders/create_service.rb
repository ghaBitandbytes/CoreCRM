module Reminders
  class CreateService
    def initialize(lead:, user:, params:)
      @lead = lead
      @user = user
      @params = params
    end

    def call
      reminder = @lead.reminders.build(@params)
      reminder.user = @user
      reminder.save
      reminder
    end
  end
end
