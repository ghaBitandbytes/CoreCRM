# app/mailers/lead_mailer.rb
class LeadMailer < ApplicationMailer
  def reminder_email(lead)
    @lead = lead
    @user = @lead.user

    mail(
      to: @user.email,
      subject: "Reminder to follow up: #{@lead.name}"
    )
  end
end
