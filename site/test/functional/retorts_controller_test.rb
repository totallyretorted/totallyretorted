require 'test_helper'

class RetortsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:retorts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create retort" do
    assert_difference('Retort.count') do
      post :create, :retort => { }
    end

    assert_redirected_to retort_path(assigns(:retort))
  end

  test "should show retort" do
    get :show, :id => retorts(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => retorts(:one).id
    assert_response :success
  end

  test "should update retort" do
    put :update, :id => retorts(:one).id, :retort => { }
    assert_redirected_to retort_path(assigns(:retort))
  end

  test "should destroy retort" do
    assert_difference('Retort.count', -1) do
      delete :destroy, :id => retorts(:one).id
    end

    assert_redirected_to retorts_path
  end
end
