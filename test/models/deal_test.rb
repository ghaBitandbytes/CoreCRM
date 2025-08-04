require "test_helper"

class DealTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: "Test User", email: "user@example.com", password: "password")
    @company = Company.create!(name: "Test Company")
    @contact = Contact.create!(first_name: "John", last_name: "Doe", email: "john@example.com", company: @company)
    @stage = Stage.create!(name: "Qualified")
    @lead = Lead.create!(name: "Test Lead", status: "New", user: @user) # Ensure required fields are filled

    @valid_attributes = {
      title: "Big Deal",
      value: 5000,
      close_date: Date.today + 5.days,
      stage: @stage,
      user: @user,
      company: @company,
      contact: @contact,
      lead: @lead
    }
  end

  test "is valid with all required attributes" do
    deal = Deal.new(@valid_attributes)
    assert deal.valid?
  end

  test "is invalid without title" do
    deal = Deal.new(@valid_attributes.merge(title: nil))
    assert_not deal.valid?
    assert_includes deal.errors[:title], "can't be blank"
  end

  test "is invalid without value" do
    deal = Deal.new(@valid_attributes.merge(value: nil))
    assert_not deal.valid?
    assert_includes deal.errors[:value], "can't be blank"
  end

  test "is invalid without close_date" do
    deal = Deal.new(@valid_attributes.merge(close_date: nil))
    assert_not deal.valid?
    assert_includes deal.errors[:close_date], "can't be blank"
  end

  test "is invalid without stage" do
    deal = Deal.new(@valid_attributes.merge(stage: nil))
    assert_not deal.valid?
    assert_includes deal.errors[:stage], "can't be blank"
  end
end
