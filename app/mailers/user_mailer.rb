class UserMailer < ApplicationMailer
default from: 'ghaziah053@gmail.com'
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to CoreCRM!")
  end
end
