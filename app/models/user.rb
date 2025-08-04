class User < ApplicationRecord
  include Roleable
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :leads
  has_many :reminders
  has_many :deals
  has_many :comments, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id

  # Callbacks
  after_initialize :set_default_role, if: :new_record?
  after_create :send_welcome_email

  private

  def set_default_role
    self.role ||= 'viewer'
  end

  def send_welcome_email
    UserOnboardingService.new(self).send_welcome_email
  rescue => e
    Rails.logger.error "Email delivery failed: #{e.message}"
  end
end
