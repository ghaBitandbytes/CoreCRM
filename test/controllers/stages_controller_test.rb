require "test_helper"

class StagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get stages_index_url
    assert_response :success
  end

  test "should get edit" do
    get stages_edit_url
    assert_response :success
  end

  test "should get update" do
    get stages_update_url
    assert_response :success
  end
end
