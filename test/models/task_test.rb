require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: "Test User", email: "user@example.com", password: "password")
    @company = Company.create!(name: "Test Co", lead: Lead.create!(name: "Lead A", user: @user))
    @task = Task.new(
      title: "Follow up",
      due_date: Date.today + 1.day,
      status: :pending,
      user: @user,
      taskable: @company
    )
  end

  test "is valid with valid attributes" do
    assert @task.valid?
  end

  test "is invalid without title" do
    @task.title = nil
    assert_not @task.valid?
    assert_includes @task.errors[:title], "can't be blank"
  end

  test "is invalid without due_date" do
    @task.due_date = nil
    assert_not @task.valid?
    assert_includes @task.errors[:due_date], "can't be blank"
  end

  test "is invalid without status" do
    @task.status = nil
    assert_not @task.valid?
    assert_includes @task.errors[:status], "can't be blank"
  end

  test "is invalid without user" do
    @task.user = nil
    assert_not @task.valid?
    assert_includes @task.errors[:user], "must exist"
  end

  test "is invalid without taskable" do
    @task.taskable = nil
    assert_not @task.valid?
    assert_includes @task.errors[:taskable], "must exist"
  end

  test "can be associated polymorphically with company" do
    assert_equal "Company", @task.taskable_type
    assert_equal @company.id, @task.taskable_id
  end

  test "destroys associated comments when destroyed" do
    @task.save!
    @task.comments.create!(body: "First comment", user: @user)
    assert_difference("Comment.count", -1) do
      @task.destroy
    end
  end

  test "status enum works correctly" do
    @task.save!
    assert_equal "pending", @task.status
    @task.done!
    assert_equal "done", @task.status
  end
end
