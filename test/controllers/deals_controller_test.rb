require "test_helper"

class DealsControllerTest < ActionDispatch::IntegrationTest
  def setup
  @salesmanager = User.create!(email: "manager@example.com", password: "password", role: "salesmanager")
  sign_in @salesmanager

  @lead = Lead.create!(
    name: "Test Lead",
    email: "lead@example.com",
    phone: "1234567890",       # <-- Add this line
    status: "Qualified",
    user: @salesmanager
  )

  @company = Company.create!(name: "Test Company", lead: @lead)
  @contact = Contact.create!(name: "Test Contact", email: "contact@test.com", company: @company)
  @stage = Stage.create!(name: "Negotiation", position: 1)

  @deal = Deal.create!(
    title: "Initial Deal",
    value: 1000,
    probability: 50,
    close_date: Date.today + 1.week,
    company: @company,
    user: @salesmanager,
    contact: @contact,
    stage: @stage,
  )
end



   test "should get index for company deals" do
    get company_deals_path(@company)
    assert_response :success
    assert_match @deal.title, @response.body
  end

 
   test "should get all deals if no company_id" do
    get deals_path
    assert_response :success
    assert_match @deal.title, @response.body
  end
   
  test "should get new" do
    get new_company_deal_path(@company)
    assert_response :success
  end

  test "should create deal" do
    assert_difference("Deal.count") do
      post company_deals_path(@company), params: {
        deal: {
          title: "New Deal",
          value: 2000,
          probability: 70,
          close_date: Date.today + 2.weeks,
          stage_id: @stage.id,
          contact_id: @contact.id
        }
      }
    end
    assert_redirected_to company_deals_path(@company)
  end

  test "should show deal" do
    get company_deal_path(@company, @deal)
    assert_response :success
    assert_match @deal.title, @response.body
  end
 
  test "should get edit" do
    get edit_company_deal_path(@company, @deal)
    assert_response :success
  end

  test "should destroy deal" do
    assert_difference("Deal.count", -1) do
      delete company_deal_path(@company, @deal)
    end
    assert_redirected_to company_deals_path(@company)
  end
 
  test "should get kanban deals" do
    get kanban_deals_path
    assert_response :success
    assert_match @deal.title, @response.body
  end

   
    test "should update stage to Won and set won_at" do
    won_stage = Stage.create!(name: "Won", position: 2)
    patch update_stage_deal_path(@deal), params: { stage_id: won_stage.id }
    assert_response :success
    @deal.reload
    assert_equal won_stage.id, @deal.stage_id
    assert_not_nil @deal.won_at
  end
 
end