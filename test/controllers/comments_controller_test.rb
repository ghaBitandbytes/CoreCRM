require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(email: "user@example.com", password: "password", username: "user1")
    @admin = User.create!(email: "admin@example.com", password: "password", username: "admin", role: "admin")
    @task = Task.create!(title: "Test Task", description: "Task details", user: @user)
    sign_in @user
  end

  test "should create comment on task" do
    assert_difference("Comment.count", 1) do
      post task_comments_path(@task), params: {
        comment: { body: "This is a test comment" }
      }
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_match "Comment added", response.body
  end

  test "should not create invalid comment" do
    assert_no_difference("Comment.count") do
      post task_comments_path(@task), params: {
        comment: { body: "" }
      }
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_match "Failed to add comment", response.body
  end

  test "should destroy own comment" do
    comment = @task.comments.create!(body: "My own comment", user: @user)

    assert_difference("Comment.count", -1) do
      delete task_comment_path(@task, comment)
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_match "Comment removed", response.body
  end

  test "should not destroy comment if not owner or admin" do
    other_user = User.create!(email: "other@example.com", password: "password", username: "other")
    comment = @task.comments.create!(body: "Other user comment", user: other_user)

    assert_no_difference("Comment.count") do
      delete task_comment_path(@task, comment)
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_match "not authorized", response.body
  end

  test "admin can destroy any comment" do
    sign_out @user
    sign_in @admin

    comment = @task.comments.create!(body: "To be deleted by admin", user: @user)

    assert_difference("Comment.count", -1) do
      delete task_comment_path(@task, comment)
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_match "Comment removed", response.body
  end

  test "should redirect if commentable is missing" do
    post "/tasks/999999/comments", params: { comment: { body: "Hi" } }

    assert_redirected_to root_path
    follow_redirect!
    assert_match "Invalid comment association", response.body
  end

  test "should handle comment not found on destroy" do
    assert_no_difference("Comment.count") do
      delete task_comment_path(@task, 999999)
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_match "Comment not found", response.body
  end
end
