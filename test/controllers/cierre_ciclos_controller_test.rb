require 'test_helper'

class CierreCiclosControllerTest < ActionController::TestCase
  setup do
    @cierre_ciclo = cierre_ciclos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cierre_ciclos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cierre_ciclo" do
    assert_difference('CierreCiclo.count') do
      post :create, cierre_ciclo: {  }
    end

    assert_redirected_to cierre_ciclo_path(assigns(:cierre_ciclo))
  end

  test "should show cierre_ciclo" do
    get :show, id: @cierre_ciclo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cierre_ciclo
    assert_response :success
  end

  test "should update cierre_ciclo" do
    patch :update, id: @cierre_ciclo, cierre_ciclo: {  }
    assert_redirected_to cierre_ciclo_path(assigns(:cierre_ciclo))
  end

  test "should destroy cierre_ciclo" do
    assert_difference('CierreCiclo.count', -1) do
      delete :destroy, id: @cierre_ciclo
    end

    assert_redirected_to cierre_ciclos_path
  end
end
