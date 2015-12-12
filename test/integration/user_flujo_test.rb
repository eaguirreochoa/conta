# require 'test_helper'
 
# class UserFlujoTest < ActionDispatch::IntegrationTest
#   fixtures :users
#   test "logear y acceder al sitio" do
#     # login via https
#     https!
#     get "/login"
#     assert_response :success

#     puts users(:eaguirre).username
#     #puts users(:eaguirre).password
 
#     #post_via_redirect "/login", username: users(:eaguirre).username, password: users(:eaguirre).password
#     #post_via_redirect "/login", username: 'eaguirre', password: '1234'
#     # assert_equal '/welcome', path
#     # assert_equal 'Welcome david!', flash[:notice]
 
#     # https!(false)
#     # get "/articles/all"
#     # assert_response :success
#     # assert assigns(:articles)
#   end
# end