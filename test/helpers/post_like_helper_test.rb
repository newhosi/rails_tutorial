require "test_helper"

class PostLikesHelperTest < ActionView::TestCase
  def setup
    @user = users(:test_user)
    @post = microposts(:seed_micropost_1)
    @like = post_likes(:one)
  end

  test "like_for returns the correct like" do
    assert_nil like_for(@user, microposts(:orange))
  end
end
