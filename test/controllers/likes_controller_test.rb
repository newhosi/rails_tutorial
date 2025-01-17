require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference "Like.count" do
      post likes_path
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "Like.count" do
      delete like_path(likes(:one))
    end
    assert_redirected_to login_url
  end

  test "should create like" do
    log_in_as(@user)
    assert_difference "Like.count", 1 do
      post likes_path, params: { micropost_id: @micropost.id }
    end
  end

  test "should destroy like" do
    log_in_as(@user)
    like = likes(:one)
    assert_difference "Like.count", -1 do
      delete like_path(like)
    end
  end
end
