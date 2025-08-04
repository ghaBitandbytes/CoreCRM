# test/models/lead_test.rb
require "test_helper"

class LeadTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "test@example.com", password: "password")
    @lead = Lead.new(
      name: "Test Lead",
      email: "lead@example.com",
      phone: "123456789",
      status: "New",
      user: @user
    )
  end

  test "is valid with valid attributes" do
    assert @lead.valid?
  end

  test "is invalid without a name" do
    @lead.name = nil
    assert_not @lead.valid?
    assert_includes @lead.errors[:name], "can't be blank"
  end

  test "is invalid without an email" do
    @lead.email = nil
    assert_not @lead.valid?
    assert_includes @lead.errors[:email], "can't be blank"
  end

  test "is invalid without a phone" do
    @lead.phone = nil
    assert_not @lead.valid?
    assert_includes @lead.errors[:phone], "can't be blank"
  end

  test "is invalid without a status" do
    @lead.status = nil
    assert_not @lead.valid?
    assert_includes @lead.errors[:status], "can't be blank"
  end

  test "belongs to a user" do
    assert_equal @user, @lead.user
  end
end
