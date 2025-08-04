require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "test@example.com", password: "password", username: "testuser")
    @company = Company.create!(name: "Test Company")
    @comment = Comment.new(body: "This is a comment", user: @user, commentable: @company)
  end

  test "is valid with valid attributes" do
    assert @comment.valid?
  end

  
end

