class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :leads
  has_many :reminders
  has_many :deals
  has_many :comments, dependent: :destroy


  # Set default role for new users
  after_initialize :set_default_role, if: :new_record?

  # ✅ Send welcome email after user is created
  after_create :send_welcome_email

  def set_default_role
    self.role ||= 'viewer'
  end

  def admin?
    role == 'admin'
  end

  def sales?
    role == 'sales'
  end

  def viewer?
    role == 'viewer'
  end

  def salesmanager?
  role == 'salesmanager'
end


  private

  def send_welcome_email
  UserMailer.welcome_email(self).deliver_later
rescue StandardError => e
  Rails.logger.error "❌ Email delivery failed: #{e.message}"
end

end
