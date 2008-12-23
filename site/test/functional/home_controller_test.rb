require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    retorts = assigns(:retorts)
    assert_not_nil retorts
    assert_equal 5, retorts.size
    tagcloud = assigns(:tagcloud)
    assert_not_nil assigns(:tagcloud)
    assert_equal Tag.tagcloud_tags.size, tagcloud.size
  end
end
