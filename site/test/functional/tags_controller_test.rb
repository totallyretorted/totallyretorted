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
    assert_no_difference('Tag.count') do
      post :create, :tag => { }
    end

    # assert_redirected_to tag_path(assigns(:tag))
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
  
  # test "alpha" do
  #     get :alpha, :letter => 's'
  #     assert_response :success
  #     results = assigns(:tags)
  #     assert_not_nil results
  #     assert_equal 1, results.size
  #     assert_equal 'south_park', results[0].value
  #     
  #   end
  
  test "search tags" do
    get :search, :search => 'South'
    assert_response :success
    assert_equal 1, assigns(:results).size
  end
  
  test "top 5 tags by alpha" do
    get :top_n_by_alpha, :format => 'xml'
    assert_response :success
    results = assigns(:records)
    assert_not_nil results
    assert_equal 2, results.size
    assert_equal 2, results[0][:tags].size
    assert_equal 1, results[1][:tags].size
  end
  
  test "top 1 tags by alpha" do
    get :top_n_by_alpha, :format => 'xml', :n => 1
    assert_response :success
    results = assigns(:records)
    assert_not_nil results
    assert_equal 2, results.size
    assert_equal 1, results[0][:tags].size
    assert_equal 1, results[1][:tags].size
  end
end
