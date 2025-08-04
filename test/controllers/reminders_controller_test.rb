require "test_helper"

class RemindersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "test@example.com", password: "password", role: "salesmanager")
    sign_in @user

    @lead = Lead.create!(
      name: "Test Lead",
      email: "lead@example.com",
      phone: "1234567890",
      status: "New",
      user: @user
    )
  end

  test "should not create reminder with invalid data" do
    assert_no_difference("Reminder.count") do
      post lead_reminders_path(@lead), params: {
        reminder: {
          title: "",  # Title is required
          notes: "Missing title",
          remind_at: "",
          status: "",
          user_id: @user.id
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "form" # confirms the 'leads/show' template was rendered
  end

  test "should create reminder with valid data" do
  assert_difference("Reminder.count", 1) do
    post lead_reminders_path(@lead), params: {
      reminder: {
        title: "Follow up call",
        notes: "Discuss project scope",
        remind_at: 2.days.from_now,
        status: "pending",
        user_id: @user.id
      }
    }
  end

  assert_redirected_to lead_path(@lead)
  assert_equal "Reminder added.", flash[:notice]
end
end
