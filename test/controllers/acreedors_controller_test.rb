require 'test_helper'

class AcreedorsControllerTest < ActionController::TestCase
  setup do
    @acreedor = acreedors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:acreedors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create acreedor" do
    assert_difference('Acreedor.count') do
      post :create, acreedor: {  }
    end

    assert_redirected_to acreedor_path(assigns(:acreedor))
  end

  test "should show acreedor" do
    get :show, id: @acreedor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @acreedor
    assert_response :success
  end

  test "should update acreedor" do
    patch :update, id: @acreedor, acreedor: {  }
    assert_redirected_to acreedor_path(assigns(:acreedor))
  end

  test "should destroy acreedor" do
    assert_difference('Acreedor.count', -1) do
      delete :destroy, id: @acreedor
    end

    assert_redirected_to acreedors_path
  end
end
