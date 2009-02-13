require 'test_helper'
require 'authenticated_test_helper'

class VotesControllerTest < ActionController::TestCase
include AuthenticatedTestHelper

  test "should get index" do
    get :index, :retort_id => retorts(:hippies)
    assert_response :success
    assert_not_nil assigns(:votes)
  end

  test "should get new" do
    get :new, :retort_id => retorts(:hippies)
    assert_response :success
  end

  test "should create vote" do
    login_as(:tester)
    assert_difference('Vote.count') do
      post :create, :vote => { }, :retort_id => retorts(:hippies)
    end

    assert_redirected_to retort_path(retorts(:hippies))
  end

  test "should show vote" do
    get :show, :id => votes(:valid_hippies).id, :retort_id => retorts(:hippies)
    assert_response :success
  end

  test "should get edit" do
    login_as(:tester)
    get :edit, :id => votes(:valid_hippies).id, :retort_id => retorts(:hippies)
    assert_response :success
  end

  test "should update vote" do
    login_as(:tester)
    put :update, :id => votes(:valid_hippies).id, :vote => { }, :retort_id => retorts(:hippies)
    assert_redirected_to retort_path(retorts(:hippies))
  end

  test "should destroy vote" do
    login_as(:tester)
    assert_difference('Vote.count', -1) do
      delete :destroy, :id => votes(:valid_hippies).id, :retort_id => retorts(:hippies)
    end

    assert_redirected_to retort_votes_path(retorts(:hippies))
  end
end
