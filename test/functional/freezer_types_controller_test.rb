require 'test_helper'

class FreezerTypesControllerTest < ActionController::TestCase
  setup do
    @freezer_type = freezer_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:freezer_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create freezer_type" do
    assert_difference('FreezerType.count') do
      post :create, freezer_type: { label: @freezer_type.label }
    end

    assert_redirected_to freezer_type_path(assigns(:freezer_type))
  end

  test "should show freezer_type" do
    get :show, id: @freezer_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @freezer_type
    assert_response :success
  end

  test "should update freezer_type" do
    put :update, id: @freezer_type, freezer_type: { label: @freezer_type.label }
    assert_redirected_to freezer_type_path(assigns(:freezer_type))
  end

  test "should destroy freezer_type" do
    assert_difference('FreezerType.count', -1) do
      delete :destroy, id: @freezer_type
    end

    assert_redirected_to freezer_types_path
  end
end
