require "test_helper"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  def setup
  @user = User.create!(email: "test@example.com", password: "password", role: "salesmanager")
  sign_in @user

  lead = Lead.create!(
    name: "Lead",
    email: "lead@example.com",
    phone: "1112223333",
    status: "New",  # or "Qualified", etc. — whatever is valid in your app
    user: @user
  )

  @company = Company.create!(name: "Test Company", lead: lead)
  @contact = Contact.create!(
    name: "Contact One",
    email: "contact@example.com",
    phone: "1234567890",
    title: "Manager",
    company: @company
  )
end

  test "should get index for company contacts" do
    get company_contacts_path(@company)
    assert_response :success
    assert_match @contact.name, @response.body
  end

  test "should show contact" do
    get contact_path(@contact)
    assert_response :success
    assert_match @contact.email, @response.body
  end
 
  test "should get new contact form" do
    get new_company_contact_path(@company)
    assert_response :success
    assert_match "New Contact", @response.body
  end

test "should create contact" do
    assert_difference("Contact.count", 1) do
      post company_contacts_path(@company), params: {
        contact: {
          name: "New Contact",
          email: "new@example.com",
          phone: "9876543210",
          title: "Engineer"
        }
      }
    end
 
    assert_redirected_to company_contacts_path(@company)
    follow_redirect!
assert_match "Contacts for", @response.body
assert_match "New Contact", @response.body

  end

  test "should get edit contact form" do
    get edit_contact_path(@contact)
    assert_response :success
    assert_match "Edit Contact", @response.body
  end
 
  test "should update contact" do
    patch contact_path(@contact), params: {
      contact: {
        name: "Updated Name"
      }
    }
 
    assert_redirected_to contact_path(@contact)
    follow_redirect!
    assert_match "Updated Name", @response.body
  end


    test "should destroy contact" do
    assert_difference("Contact.count", -1) do
      delete contact_path(@contact)
    end

  end
end
