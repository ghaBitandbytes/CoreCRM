class Lead < ApplicationRecord
  belongs_to :user, optional: false

  validates :name, :email, :phone, :status, presence: true

   has_one :company, dependent: :destroy
  has_many :reminders, dependent: :destroy
end

