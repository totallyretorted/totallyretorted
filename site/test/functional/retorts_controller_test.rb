require 'test_helper'

class RetortsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    retorts = assigns(:retorts)
    assert_not_nil retorts
    assert_equal 6, retorts.size
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
    get :show, :id => retorts(:kennys_dad).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => retorts(:kennys_dad).id
    assert_response :success
  end

  test "should update retort" do
    put :update, :id => retorts(:kennys_dad).id, :retort => { }
    assert_redirected_to retort_path(assigns(:retort))
  end

  test "should destroy retort" do
    assert_difference('Retort.count', -1) do
      delete :destroy, :id => retorts(:kennys_dad).id
    end

    assert_redirected_to retorts_path
  end
  
  test "should return a subset of retorts" do
    #fixtures :all
    
    get :screenzero
    assert_response :success
    retorts = assigns(:retorts)
    assert_not_nil retorts
    assert_equal 5, retorts.size
  end
end
