require 'test_helper'

class AjustesControllerTest < ActionController::TestCase
  setup do
    @ajuste = ajustes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ajustes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ajuste" do
    assert_difference('Ajuste.count') do
      post :create, ajuste: {  }
    end

    assert_redirected_to ajuste_path(assigns(:ajuste))
  end

  test "should show ajuste" do
    get :show, id: @ajuste
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ajuste
    assert_response :success
  end

  test "should update ajuste" do
    patch :update, id: @ajuste, ajuste: {  }
    assert_redirected_to ajuste_path(assigns(:ajuste))
  end

  test "should destroy ajuste" do
    assert_difference('Ajuste.count', -1) do
      delete :destroy, id: @ajuste
    end

    assert_redirected_to ajustes_path
  end
end
