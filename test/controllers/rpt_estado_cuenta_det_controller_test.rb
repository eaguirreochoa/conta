require 'test_helper'

class RptEstadoCuentaDetControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

end
