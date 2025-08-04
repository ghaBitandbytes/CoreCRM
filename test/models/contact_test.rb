require "test_helper"

class ContactTest < ActiveSupport::TestCase
  def setup
    PublicActivity.enabled = false

    @user = User.create!(name: "Test User", email: "user@example.com", password: "password")
    @lead = Lead.create!(name: "Test Lead", user: @user)
    @company = Company.create!(name: "Test Company", lead: @lead)

    @contact = @company.contacts.create!(name: "John Doe", email: "john@example.com")
    @stage = Stage.create!(name: "Prospecting")
    @close_date = Date.today + 5.days
  end

  test "is valid with valid attributes" do
    assert @contact.valid?
  end

  test "is invalid without a company" do
    @contact.company = nil
    assert_not @contact.valid?
  end

  test "belongs to a company" do
    assert_equal @company, @contact.company
  end

  test "has many deals" do
    deal = @contact.deals.create!(
      title: "Test Deal",
      value: 1000,
      user: @user,
      company: @company,
      stage: @stage,
      close_date: @close_date
    )
    assert_includes @contact.deals, deal
  end

  test "destroys associated deals when contact is destroyed" do
    @contact.deals.create!(
      title: "Deal to delete",
      value: 2000,
      user: @user,
      company: @company,
      stage: @stage,
      close_date: @close_date
    )
    assert_difference("Deal.count", -1) do
      @contact.destroy
    end
  end
end
