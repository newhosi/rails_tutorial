require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:test_user)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template "password_resets/new"

    # invalid email address
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template "password_resets/new"

    # valid email address
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    # invalid email address in edit form
    user = assigns(:user)
    get edit_password_reset_path(user.reset_token, email: "")

    # valid email address in edit form, but invalid user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)

    # valid email address in edit form, but invalid token
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_url

    # valid email address and token in edit form
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template "password_resets/edit"
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # password validation with not matching password and confirmation
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: { password:              "foobaz",
              password_confirmation: "invalid" } }
    assert_select "div.field_with_errors"

    # password validation with empty password
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: { password:              "",
              password_confirmation: "" } }
    assert_select "div.field_with_errors"

    # success
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: { password:              "password",
              password_confirmation: "password" } }
    assert_nil user.reload.reset_digest
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, params: { password_reset: { email: @user.email } }

    user = assigns(:user)
    user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: { password:              "password",
              password_confirmation: "password" } }
    assert_response :redirect
    follow_redirect!
    assert_match "Password\ reset\ has\ expired", response.body
  end
end
