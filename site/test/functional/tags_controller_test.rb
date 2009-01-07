require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tag" do
    assert_difference('Tag.count') do
      post :create, :tag => { }
    end

    assert_redirected_to tag_path(assigns(:tag))
  end

  test "should show tag" do
    get :show, :id => tags(:cartman_tag).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tags(:cartman_tag).id
    assert_response :success
  end

  test "should update tag" do
    put :update, :id => tags(:cartman_tag).id, :tag => { }
    assert_redirected_to tag_path(assigns(:tag))
  end

  test "should destroy tag" do
    assert_difference('Tag.count', -1) do
      delete :destroy, :id => tags(:cartman_tag).id
    end

    assert_redirected_to tags_path
  end
  
  test "search" do
    get :search, :search => 'cartman'
    assert_response :success
    results = assigns(:results)
    assert_not_nil results
    assert_equal 1, results.size
    assert_equal 'cartman', results[0].value
  end
  
  test "alpha" do
    get :alpha, :letter => 's'
    assert_response :success
    results = assigns(:tags)
    assert_not_nil results
    assert_equal 1, results.size
    assert_equal 'south_park', results[0].value
    
  end
end
