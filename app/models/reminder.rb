class Reminder < ApplicationRecord
  belongs_to :lead
  belongs_to :user
  scope :upcoming, -> { where("remind_at >= ? AND remind_at <= ?", Time.current, 24.hours.from_now).order(:remind_at) }

end
