require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
    @non_admin = users(:test_user_2)
  end

  test "index including pagination" do
    log_in_as(@user)
    get users_path
    assert_template "users/index"
    assert_select "nav.pagy.nav"
    assert_select "span.pagy.info"
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@user)
    get users_path
    assert_template "users/index"
    assert_select "nav.pagy.nav"
    assert_select "span.pagy.info"
    assert_select "svg"
    assert_difference "User.count", -1 do
      delete user_path(@non_admin)
    end
  end
end
