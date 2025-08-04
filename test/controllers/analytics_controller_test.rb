require "test_helper"

class AnalyticsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(email: "user@example.com", password: "password")
    sign_in @user

    # Setup sample data
    @company = Company.create!(name: "Acme Inc", industry: "Tech", user: @user)
    @lead1 = Lead.create!(name: "Lead 1", source: "Web", user: @user, created_at: 2.months.ago)
    @lead2 = Lead.create!(name: "Lead 2", source: "Referral", user: @user, created_at: 1.month.ago, converted_at: Date.today, status: "Contacted")

    stage_won = Stage.create!(name: "Won")
    stage_lost = Stage.create!(name: "Lost")
    stage_open = Stage.create!(name: "Negotiation")

    @deal1 = Deal.create!(
      title: "Deal 1", value: 10000, company: @company, user: @user,
      stage: stage_won, won_at: Date.today - 5.days, created_at: Date.today - 20.days
    )

    @deal2 = Deal.create!(
      title: "Deal 2", value: 8000, company: @company, user: @user,
      stage: stage_lost
    )

    @deal3 = Deal.create!(
      title: "Deal 3", value: 12000, company: @company, user: @user,
      stage: stage_open, close_date: Date.today + 10.days
    )
  end

  test "should get lead_conversion" do
    get lead_conversion_path
    assert_response :success

    assert assigns(:monthly_leads_created).present?
    assert assigns(:monthly_leads_converted).present?
    assert assigns(:conversion_funnel).present?
  end

  test "should get analytics" do
    get analytics_path
    assert_response :success

    assert assigns(:win_loss_ratio).present?
    assert assigns(:avg_deal_cycle_time).present?
    assert assigns(:forecast_revenue).present?
    assert assigns(:leads_by_month).present?
    assert assigns(:converted_leads_by_month).present?
    assert assigns(:lead_sources).present?
    assert assigns(:deal_distribution_by_industry).present?
  end

  test "unauthenticated users should be redirected from lead_conversion" do
    sign_out @user
    get lead_conversion_path
    assert_redirected_to new_user_session_path
  end

  test "unauthenticated users should be redirected from analytics" do
    sign_out @user
    get analytics_path
    assert_redirected_to new_user_session_path
  end
end
