require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:test_user)
  end

  test "profile display" do
    get user_path(@user)
    assert_template "users/show"
    assert_match @user.microposts.count.to_s, response.body
    assert_select "span.pagy"
    _, paginated_microposts = pagy(@user.microposts, page: 1)
    paginated_microposts.each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
