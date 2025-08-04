class Lead < ApplicationRecord
  belongs_to :user, optional: false


  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :status, presence: true

   has_one :company, dependent: :destroy
  has_many :reminders, dependent: :destroy
end

