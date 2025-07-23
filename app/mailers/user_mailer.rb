class UserMailer < ApplicationMailer
  default from: 'ghaziah053@gmail.com'

  def welcome_email
    @user = params[:user]
    return unless @user.present?

    mail(to: @user.email, subject: "Welcome to CoreCRM!")
  end
end
