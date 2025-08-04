require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "should set default role to viewer" do
    user = User.new
    user.valid? # triggers callbacks
    assert_equal "viewer", user.role
  end

  test "admin? should return true if role is admin" do
    @user.role = "admin"
    assert @user.admin?
  end

  test "sales? should return true if role is sales" do
    @user.role = "sales"
    assert @user.sales?
  end

  test "viewer? should return true if role is viewer" do
    @user.role = "viewer"
    assert @user.viewer?
  end

  test "salesmanager? should return true if role is salesmanager" do
    @user.role = "salesmanager"
    assert @user.salesmanager?
  end

  test "should have many leads" do
    assert_respond_to @user, :leads
  end

  test "should have many reminders" do
    assert_respond_to @user, :reminders
  end

  test "should have many deals" do
    assert_respond_to @user, :deals
  end

  test "should have many comments" do
    assert_respond_to @user, :comments
  end

  test "should have many notifications" do
    assert_respond_to @user, :notifications
  end

end
