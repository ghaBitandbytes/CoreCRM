require "test_helper"

class LeadsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
  @user = User.create!(email: "user@example.com", password: "password", role: "sales")

  # Create the lead first (without a company for now)
  @lead = Lead.new(
    name: "Test Lead",
    email: "lead@example.com",
    phone: "1234567890",
    source: "LinkedIn",
    status: "New",
    user: @user
  )
   @manager = User.create!(
    email: "manager@example.com",
    password: "password",
    role: "salesmanager"
  )

  @admin = User.create!(
    email: "admin@example.com",
    password: "password",
    role: "admin"
  )

  # Create company and associate it with lead
  @company = Company.new(name: "Test Company", lead: @lead)

  # Now link lead back to company (optional if your model requires)
  @lead.company = @company

  # Save both
  @lead.save!
  @company.save!
end


    test "should get index" do
    sign_in @user
    get leads_path
    assert_response :success
    assert_select "h1", /Leads/i
  end

test "should filter by query" do
  sign_in @user
  lead = Lead.create!(
    name: "Test Lead",
    email: "test@example.com",
    phone: "1234567890",
    status: "New", # or any valid status from your app
    user: @user
  )

  get leads_path(query: "Test")
  assert_response :success
end

  test "should filter by status" do
    sign_in @user
    get leads_path(status: "hot")
    assert_response :success
  end

  test "should get show" do
  sign_in @user
  lead = Lead.create!(
    name: "Test Show Lead",
    email: "show@example.com",
    phone: "1234567890",
    status: "New",
    user: @user # associate lead with signed-in user
  )

  get lead_path(lead)
  assert_response :success
  assert_match lead.name, @response.body
end

test "should get new" do
    sign_in @user
    get new_lead_path
    assert_response :success
  end
 
 test "should create lead" do
    sign_in @user
    assert_difference("Lead.count") do
      post leads_path, params: {
        lead: {
          name: "New Lead",
          email: "new@example.com",
          phone: "9876543210",
          source: "Website",
          status: "New",
        }
      }
    end
    assert_redirected_to Lead.last
  end

  test "should create lead and redirect salesmanager" do
  sign_in @manager

  post leads_path, params: {
    lead: {
      name: "Manager Lead",
      email: "mgr@example.com",
      phone: "9999999999",
      source: "Cold Call",
      status: "New",
      company: @company.name
    }
  }

  assert_redirected_to salesmanager_dashboard_path
end

test "should get edit" do
    sign_in @user
    get edit_lead_path(@lead)
    assert_response :success
  end
 
  test "should update lead" do
    sign_in @user
    patch lead_path(@lead), params: {
      lead: { name: "Updated Lead" }
    }
    assert_redirected_to lead_path(@lead)
    @lead.reload
    assert_equal "Updated Lead", @lead.name
  end

  test "salesmanager qualifies lead and timestamps" do
    sign_in @manager
    @lead.update!(status: "New", user: @manager)
    patch lead_path(@lead), params: {
      lead: { status: "Qualified" }
    }
    assert_redirected_to salesmanager_dashboard_path
    @lead.reload
    assert_equal "Qualified", @lead.status
    assert_not_nil @lead.converted_at
  end

   test "should get kanban" do
    sign_in @user
    get kanban_leads_path
    assert_response :success
  end

  test "should destroy lead" do
    sign_in @admin
    assert_difference("Lead.count", -1) do
      delete lead_path(@lead)
    end
    assert_redirected_to leads_path
  end

  test "should export leads to CSV" do
  sign_in @user
  get export_leads_path(format: :csv)
  assert_response :success
  assert_equal "text/csv", @response.media_type
  assert_match "Name", @response.body  # ✅ Capitalized
end

test "should redirect if lead not found" do
    sign_in @user
    get lead_path(-1)
    assert_redirected_to leads_path
    follow_redirect!
    assert_match "Lead not found", response.body
  end
 
 
end