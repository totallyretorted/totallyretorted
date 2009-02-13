require 'test_helper'

class TagRetortsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, :tag_id => tags(:south_park_tag)
    assert_response :success
    assert_not_nil assigns(:retorts)
  end
end
