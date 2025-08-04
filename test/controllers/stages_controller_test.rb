require "test_helper"

class StagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stage = Stage.create!(name: "Initial Contact", position: 1)
  end


  test "should get new" do
    get new_stage_path
    assert_response :success
  end


  test "should get edit" do
    get edit_stage_path(@stage)
    assert_response :success
  end

  test "should create stage" do
    assert_difference("Stage.count", 1) do
      post stages_path, params: { stage: { name: "Qualified", position: 2 } }
    end
 
    assert_redirected_to stages_path
    follow_redirect!
  end

  test "should update stage" do
  patch stage_path(@stage), params: { stage: { name: "Updated Stage", position: 3 } }
  assert_redirected_to stages_path
  follow_redirect!
  # assert_match "Stage updated successfully", response.body   # Remove or comment out this line
  @stage.reload
  assert_equal "Updated Stage", @stage.name
end

 test "should get index" do
    get stages_path
    assert_response :success
  end
 

test "should destroy stage" do
    assert_difference("Stage.count", -1) do
      delete stage_path(@stage)
    end
 
    assert_redirected_to stages_path
    follow_redirect!
  end
 
end
