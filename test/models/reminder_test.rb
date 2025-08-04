require "test_helper"

class ReminderTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: "Test User", email: "user@example.com", password: "password")
    @lead = Lead.create!(name: "Test Lead", user: @user)
    @reminder = Reminder.new(remind_at: 1.hour.from_now, user: @user, lead: @lead)
  end

  test "is valid with valid attributes" do
    assert @reminder.valid?
  end

  test "is invalid without remind_at" do
    @reminder.remind_at = nil
    assert_not @reminder.valid?
    assert_includes @reminder.errors[:remind_at], "can't be blank"
  end

  test "is invalid without user" do
    @reminder.user = nil
    assert_not @reminder.valid?
    assert_includes @reminder.errors[:user], "must exist"
  end

  test "is invalid without lead" do
    @reminder.lead = nil
    assert_not @reminder.valid?
    assert_includes @reminder.errors[:lead], "must exist"
  end

  test "upcoming scope returns reminders within next 24 hours" do
    @reminder.save!
    later_reminder = Reminder.create!(remind_at: 23.hours.from_now, user: @user, lead: @lead)
    past_reminder = Reminder.create!(remind_at: 1.hour.ago, user: @user, lead: @lead)
    future_reminder = Reminder.create!(remind_at: 2.days.from_now, user: @user, lead: @lead)

    upcoming = Reminder.upcoming

    assert_includes upcoming, @reminder
    assert_includes upcoming, later_reminder
    assert_not_includes upcoming, past_reminder
    assert_not_includes upcoming, future_reminder
  end
end
