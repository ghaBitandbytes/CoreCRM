require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  def setup
  PublicActivity.enabled = false

  @user = User.create!(name: "Test User", email: "user@example.com", password: "password")
  @lead = Lead.create!(name: "Test Lead", user: @user)
  @company = Company.create!(name: "Test Company", lead: @lead)

  @contact = @company.contacts.create!(name: "John Doe", email: "john@example.com")
  @stage = Stage.create!(name: "Negotiation")  # assuming you have a Stage model
  @close_date = Date.today + 7.days
end


  test "is valid with valid attributes" do
    assert @company.valid?
  end

  test "is invalid without a name" do
    @company.name = nil
    assert_not @company.valid?
    assert_includes @company.errors[:name], "can't be blank"
  end

  test "belongs to a lead" do
    assert_equal @lead, @company.lead
  end

  test "has many deals" do
    @company.save!
   deal = @company.deals.create!(
  title: "Test Deal",
  value: 1000,
  user: @user,
  contact: @contact,
  stage: @stage,
  close_date: @close_date
  )
  end

  test "has many contacts" do
    @company.save!
    contact = @company.contacts.create!(name: "Test Contact", email: "contact@example.com")
    assert_includes @company.contacts, contact
  end

  test "has many tasks (polymorphic)" do
    @company.save!
    task = @company.tasks.create!(title: "Follow up", due_date: Date.today, user: @user)
    assert_includes @company.tasks, task
  end

  test "destroys associated deals when destroyed" do
    @company.save!
    @company.deals.create!(
  title: "Deal to delete",
  value: 1000,
  user: @user,
  contact: @contact,
  stage: @stage,
  close_date: @close_date
)
  end

  test "destroys associated contacts when destroyed" do
  company = Company.create!(name: "With Contact", lead: @lead)
  company.contacts.create!(name: "Contact to delete", email: "test@example.com")

  assert_difference("Contact.count", -1) do
    company.destroy
  end
end

test "destroys associated tasks when destroyed" do
  @company.save!
  @company.tasks.create!(title: "Task to delete", due_date: Date.today, user: @user)
  assert_difference("Task.count", -1) do
    @company.destroy
  end
end


end
