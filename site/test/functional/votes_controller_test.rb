require 'test_helper'

class VotesControllerTest < ActionController::TestCase
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
    assert_difference('Vote.count') do
      post :create, :vote => { }, :retort_id => retorts(:hippies)
    end

    assert_redirected_to retort_vote_path(retorts(:hippies), assigns(:vote))
  end

  test "should show vote" do
    get :show, :id => votes(:valid_hippies).id, :retort_id => retorts(:hippies)
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => votes(:valid_hippies).id, :retort_id => retorts(:hippies)
    assert_response :success
  end

  test "should update vote" do
    put :update, :id => votes(:valid_hippies).id, :vote => { }, :retort_id => retorts(:hippies)
    assert_redirected_to retort_vote_path(retorts(:hippies), assigns(:vote))
  end

  test "should destroy vote" do
    assert_difference('Vote.count', -1) do
      delete :destroy, :id => votes(:valid_hippies).id, :retort_id => retorts(:hippies)
    end

    assert_redirected_to retort_votes_path(retorts(:hippies))
  end
end
