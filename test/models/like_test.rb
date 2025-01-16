require "test_helper"

class LikeTest < ActiveSupport::TestCase
  def setup
    @like = Like.new(user_id: users(:test_user).id,
                     micropost_id: microposts(:orange).id)
  end

  test "should be valid" do
    assert @like.valid?
  end

  test "should require a user_id" do
    @like.user_id = nil
    assert_not @like.valid?
  end

  test "should require a micropost_id" do
    @like.micropost_id = nil
    assert_not @like.valid?
  end
end
