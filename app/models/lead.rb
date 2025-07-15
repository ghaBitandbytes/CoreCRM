class Lead < ApplicationRecord
  belongs_to :user, optional: false

  has_one :company, dependent: :destroy
  has_many :reminders, dependent: :destroy

end
