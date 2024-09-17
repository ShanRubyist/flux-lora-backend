require "test_helper"

class ShowcasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @showcase = showcases(:one)
  end

  test "should get index" do
    get showcases_url, as: :json
    assert_response :success
  end

  test "should create showcase" do
    assert_difference("Showcase.count") do
      post showcases_url, params: { showcase: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show showcase" do
    get showcase_url(@showcase), as: :json
    assert_response :success
  end

  test "should update showcase" do
    patch showcase_url(@showcase), params: { showcase: {  } }, as: :json
    assert_response :success
  end

  test "should destroy showcase" do
    assert_difference("Showcase.count", -1) do
      delete showcase_url(@showcase), as: :json
    end

    assert_response :no_content
  end
end
