require "test_helper"

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "test@example.com", password: "password", role: "salesmanager")
    sign_in @user

    @lead = Lead.create!(name: "Lead Inc.", email: "lead@example.com", phone: "1234567890", user: @user, status: "Qualified")
    @company = Company.create!(name: "Test Company", lead: @lead)

    @contact = Contact.create!(name: "John Doe", email: "john@example.com", phone: "1234567890", company: @company)
    @stage = Stage.create!(name: "Initial", position: 1)

    @deal = Deal.create!(
      title: "Sample Deal",
      value: 1000,
      close_date: Date.today + 7.days,
      user: @user,
      company: @company,
      contact: @contact,
      stage: @stage
    )
  end

  test "should get index" do
    get companies_path
    assert_response :success
    assert_match @company.name, @response.body
  end

  test "should show company" do
    get company_path(@company)
    assert_response :success
    assert_match @contact.name, @response.body
  end
 
  test "should get new" do
    get new_company_path
    assert_response :success
  end

 test "should not create company with invalid data" do
    post companies_path, params: { company: { name: "" } }
    assert_response :success
    assert_select "form"
  end
 
  test "should get edit" do
    get edit_company_path(@company)
    assert_response :success
  end
 
  test "should update company" do
    patch company_path(@company), params: { company: { name: "Updated Co" } }
    assert_redirected_to company_path(@company)
    @company.reload
    assert_equal "Updated Co", @company.name
  end

  test "should not update company with invalid data" do
    patch company_path(@company), params: { company: { name: "" } }
    assert_response :success
    assert_select "form"
  end
 
  test "should export company PDF" do
    get export_pdf_company_path(@company, format: :pdf)
    assert_response :success
    assert_equal "application/pdf", response.media_type
  end
 
    test "should get all companies" do
    get all_companies_path
    assert_response :success
    assert_match @company.name, @response.body
  end
end


