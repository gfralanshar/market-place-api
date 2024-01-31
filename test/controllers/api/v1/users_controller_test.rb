require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'should show user' do
    get api_v1_user_path(@user), as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal @user.email, json_response['email']
  end

  test 'should create a new user if valid user' do
    assert_difference "User.count", 1 do
      post api_v1_users_path, params: {user: {email: "foo@gmail.com", password: "secret"}}, as: :json
    end

    assert_response :created
  end

  test 'should not create a new user if invalid user' do
    assert_no_difference "User.count" do
      post api_v1_users_path, params: { user: {email: @user.email, password: "secret"}}, as: :json
    end

    assert_response :unprocessable_entity
  end

  test 'update the user if valid params' do
    user_before_update = @user.email
    patch api_v1_user_path(@user), params: {user: {email: "notoneagain@gmail.com"}}, as: :json
    assert_response :success
    @user.reload
    user_after_update = @user.email

    assert_not_same user_after_update, user_before_update
  end

  test 'not updating the user if invalid params' do
    patch api_v1_user_path(@user), params: {user: {email: ""}}, as: :json
    assert_response :unprocessable_entity
  end
end
