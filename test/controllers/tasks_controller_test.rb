require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      email: "user@example.com",
      password: "password",
      role: "salesmanager" # ✅ Required by TaskPolicy
    )
    sign_in @user

    @lead = Lead.create!(
      name: "Test Lead",
      email: "lead@example.com",
      phone: "1234567890",
      status: "Qualified",
      user: @user
    )

    @company = Company.create!(
      name: "Test Company",
      industry: "Software",
      lead: @lead
    )

    @contact = Contact.create!(
      name: "Test Contact",
      email: "contact@example.com",
      company: @company
    )

    @stage = Stage.create!(name: "Initial")

    @deal = Deal.create!(
      title: "Test Deal",
      value: 10000,
      close_date: Date.today + 5.days,
      company: @company,
      contact: @contact,
      stage: @stage,
      user: @user
    )
    @task = Task.create!(
  title: "Follow up",
  status: "pending",
  due_date: Date.today + 3.days,
  user: @user,
  taskable: @deal
)

  end

  test "should get new task form for deal" do
    get new_deal_task_path(@deal)
    assert_response :success
    assert_select "form"
  end

 test "should create task for deal" do
  assert_difference("Task.count", 1) do
    post deal_tasks_path(@deal), params: {
      task: {
        title: "New Task",
        due_date: Date.today + 5.days,
        status: "pending" # ✅ must be either "pending" or "done"
      }
    }
  end

  assert_redirected_to deal_path(@deal)
  follow_redirect!
assert_match "New Task", response.body
end

  test "should get edit" do
  get edit_deal_task_path(@deal, @task)
  assert_response :success
end

test "should update task" do
  patch deal_task_path(@deal, @task), params: {
    task: {
      title: "Updated Title"
    }
  }
  assert_redirected_to deal_path(@deal)
  @task.reload
  assert_equal "Updated Title", @task.title
end

test "should destroy task" do
    assert_difference("Task.count", -1) do
      delete deal_task_path(@deal, @task)
    end
 
    assert_redirected_to root_path
    follow_redirect!
  end

end
