require "test_helper"

class SalesmanagerControllerTest < ActionDispatch::IntegrationTest
def setup
  @admin = User.create!(email: "admin@example.com", password: "password", role: "admin")
  @salesmanager = User.create!(email: "manager@example.com", password: "password", role: "salesmanager")
  @user = User.create!(email: "user@example.com", password: "password", role: "user")

  @lead = Lead.create!(
    name: "Important Lead",
    status: "New",
    email: "lead@example.com",         
    phone: "1234567890",                
    user: @salesmanager
  )
end

test "should redirect unauthenticated user" do
  get salesmanager_dashboard_path
  assert_redirected_to new_user_session_path
end

test "should allow admin to access index" do
  sign_in @admin
  get salesmanager_dashboard_path
  assert_response :success
  assert_select "h1", "Sales Manager"
end

test "should allow salesmanager to access index" do
  sign_in @salesmanager
  get salesmanager_dashboard_path
  assert_response :success
end

test "should deny access to regular user" do
  sign_in @user
  get salesmanager_dashboard_path
  assert_redirected_to root_path
  assert_equal "Access denied. Only Sales Managers and Admins allowed.", flash[:alert]
end

 
 
end
