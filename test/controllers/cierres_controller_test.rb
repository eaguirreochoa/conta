require 'test_helper'

class CierresControllerTest < ActionController::TestCase
  setup do
    @cierre = cierres(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cierres)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cierre" do
    assert_difference('Cierre.count') do
      post :create, cierre: {  }
    end

    assert_redirected_to cierre_path(assigns(:cierre))
  end

  test "should show cierre" do
    get :show, id: @cierre
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cierre
    assert_response :success
  end

  test "should update cierre" do
    patch :update, id: @cierre, cierre: {  }
    assert_redirected_to cierre_path(assigns(:cierre))
  end

  test "should destroy cierre" do
    assert_difference('Cierre.count', -1) do
      delete :destroy, id: @cierre
    end

    assert_redirected_to cierres_path
  end
end
