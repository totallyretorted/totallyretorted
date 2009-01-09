require 'test_helper'

class AttributionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:attributions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create attribution" do
    assert_difference('Attribution.count') do
      post :create, :attribution => { }
    end

    assert_redirected_to attribution_path(assigns(:attribution))
  end

  test "should show attribution" do
    get :show, :id => attributions(:cartman).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => attributions(:cartman).id
    assert_response :success
  end

  test "should update attribution" do
    put :update, :id => attributions(:cartman).id, :attribution => { }, :format => 'html'
    assert_redirected_to attribution_path(assigns(:attribution))
  end

  test "should destroy attribution" do
    assert_difference('Attribution.count', -1) do
      delete :destroy, :id => attributions(:cartman).id
    end

    assert_redirected_to attributions_path
  end
end
