require "test_helper"

class StageTest < ActiveSupport::TestCase
  def setup
    @stage = Stage.create!(name: "Prospecting", position: 1)
  end

  test "is valid with valid attributes" do
    assert @stage.valid?
  end

  test "has many deals" do
    user = User.create!(name: "Test User", email: "test@example.com", password: "password")
    lead = Lead.create!(name: "Lead A", user: user)
    company = Company.create!(name: "Test Co", lead: lead)
    contact = company.contacts.create!(name: "Test Contact", email: "contact@example.com")

    deal1 = Deal.create!(
      title: "Deal 1",
      value: 1000,
      user: user,
      contact: contact,
      company: company,
      stage: @stage,
      close_date: Date.today + 1.week
    )

    deal2 = Deal.create!(
      title: "Deal 2",
      value: 2000,
      user: user,
      contact: contact,
      company: company,
      stage: @stage,
      close_date: Date.today + 2.weeks
    )

    assert_includes @stage.deals, deal1
    assert_includes @stage.deals, deal2
  end

  test "default scope orders by position" do
    Stage.create!(name: "Negotiation", position: 3)
    Stage.create!(name: "Qualified", position: 2)

    ordered_names = Stage.all.pluck(:name)
    assert_equal ["Prospecting", "Qualified", "Negotiation"], ordered_names
  end
end
