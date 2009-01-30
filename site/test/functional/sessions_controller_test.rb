require 'test_helper'
require 'authenticated_test_helper'

class SessionsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  test "verify restful client credentials" do
    authorize_as(:valid)
    post :verify, :format => 'xml'
    assert_response :success
  end

  test "invalid restful client credentials" do
    @request.env["HTTP_AUTHORIZATION"] = ActionController::HttpAuthentication::Basic.encode_credentials('quentin', 'badpassword')
    post :verify, :format => 'xml'
    assert_response :not_acceptable
  end
  
  test "check create action disabled for restful clients" do
    authorize_as(:valid)
    post :create, :format => 'xml'
    assert_response :forbidden  
  end
  
  test "check verify disabled for browser clients" do
    login_as(:valid)
    post :verify
    assert_redirected_to :action => 'new'
  end
end