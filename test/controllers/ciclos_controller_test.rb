require 'test_helper'

class CiclosControllerTest < ActionController::TestCase
  setup do
    @ciclo = ciclos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ciclos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ciclo" do
    assert_difference('Ciclo.count') do
      post :create, ciclo: {  }
    end

    assert_redirected_to ciclo_path(assigns(:ciclo))
  end

  test "should show ciclo" do
    get :show, id: @ciclo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ciclo
    assert_response :success
  end

  test "should update ciclo" do
    patch :update, id: @ciclo, ciclo: {  }
    assert_redirected_to ciclo_path(assigns(:ciclo))
  end

  test "should destroy ciclo" do
    assert_difference('Ciclo.count', -1) do
      delete :destroy, id: @ciclo
    end

    assert_redirected_to ciclos_path
  end
end
