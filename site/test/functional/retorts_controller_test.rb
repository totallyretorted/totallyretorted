require 'test_helper'
require 'assert_xpath'
require 'assert2'

class RetortsController
  def rescue_action(e)
    raise e
  end
  
  def _renderizer
    render params[:args]
  end
end

class RetortsControllerTest < ActionController::TestCase
  def render(args)
    get :_renderizer, :args => args
  end
  
  # test "should show toolbar" do
  #    render :partial => 'common/toolbar'
  #    assert_xpath :div, :toolbar do
  #      assert_xpath :div, :toolbar_main do
  #        assert_xpath :div, :search
  #      end
  #    end        
  #  end
  
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

  test "should not create retort with no params" do
    assert_no_difference('Retort.count') do
      post :create, :retort => { }
    end
    # retort = assigns(:retort)
    #     assert_redirected_to retort_path(retort)
  end

  test "should create retort with just content" do  
    assert_difference('Retort.count') do
      post :create, {:retort => { :content => 'this is a test' }}
    end
    retort = assigns(:retort)
    assert retort.rating
    assert_equal 0, retort.tags.size
    assert_redirected_to retort_path(retort)
  end

  test "should create retort with content and one tag" do
    assert_difference('Retort.count') do
      post :create, {:retort => { :content => 'this is also a test' }, :tags => { :value => 'one' }}
    end
    retort = assigns(:retort)
    assert retort.rating
    assert retort.tags
    assert_equal 1, retort.tags.size
    assert_redirected_to retort_path(retort)
  end

  test "should create retort with content and mult tags" do
    assert_difference('Retort.count') do
      post :create, {:retort => { :content => 'this is another test' }, :tags => { :value => 'one, two' }}
    end    
    retort = assigns(:retort)
    assert retort.rating
    assert retort.tags
    assert_equal 2, retort.tags.size
    assert_redirected_to retort_path(retort)
  end

  test "should create retort with contetn tags attrib" do
    assert_difference('Retort.count') do
      post :create, {:retort => { :content => 'this is one more test' }, :tags => { :value => 'one and two, two, three' }, :attribution => { :who => 'fred'}}
    end  
    retort = assigns(:retort)
    assert retort.rating
    assert retort.attribution
    assert retort.tags
    assert_equal 3, retort.tags.size
    assert_redirected_to retort_path(retort)
  end

  test "should not create retort with invalid when param value" do
    assert_no_difference('Retort.count') do
      post :create, {:retort => { :content => 'this is the last test' }, :tags => { :value => 'one and two, two, three' }, :attribution => { :when => 'fred'}}
      
    end
    # retort = assigns(:retort)
    #     assert_redirected_to retort_path(retort)
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
