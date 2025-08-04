# app/services/user_onboarding_service.rb
class UserOnboardingService
  def initialize(user)
    @user = user
  end

  def send_welcome_email
    UserMailer.welcome_email(@user).deliver_later
  end
end
