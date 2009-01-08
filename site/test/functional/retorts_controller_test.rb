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

    assert_difference('Retort.count') do
      post :create, {:retort => { :content => 'this is a test' }}
    end

    assert_difference('Retort.count') do
      post :create, {:retort => { :content => 'this is also a test' }, :tags => { :value => 'one' }}
    end

    assert_difference('Retort.count') do
      post :create, {:retort => { :content => 'this is another test' }, :tags => { :value => 'one, two' }}
    end    

    assert_difference('Retort.count') do
      post :create, {:retort => { :content => 'this is one more test' }, :tags => { :value => 'one and two, two, three' }, :attribution => { :who => 'fred'}}
    end  

    assert_difference('Retort.count') do
      post :create, {:retort => { :content => 'this is the last test' }, :tags => { :value => 'one and two, two, three' }, :attribution => { :when => 'fred'}}
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
