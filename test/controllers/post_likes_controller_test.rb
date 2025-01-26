require "test_helper"

class PostLikesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference "PostLike.count" do
      post micropost_likes_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "PostLike.count" do
      delete micropost_like_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test "should create like" do
    log_in_as(@user)
    assert_difference "PostLike.count", 1 do
      post micropost_likes_path(@micropost)
    end
  end

  test "should destroy like" do
    log_in_as(@user)
    @user.like(@micropost)
    assert_difference "PostLike.count", -1 do
      delete micropost_like_path(@micropost)
    end
  end
end
