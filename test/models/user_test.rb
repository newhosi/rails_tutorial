require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "example",
                     email: "user@example.com",
                     password: "foobar",
                     password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com USERfoo.COM A_US-ER@foo.bar.org. foo@bar..com]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = duplicate_user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPLe.Com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email # reload 하면 select 쿼리 발생함.
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6 # Multiple Assignment
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "test content")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    test_user = users(:test_user)
    test_user_2 = users(:test_user_2)
    assert_not test_user.following?(test_user_2)
    test_user.follow(test_user_2)
    assert test_user.following?(test_user_2)
    test_user_2.followers.include?(test_user)
    test_user.unfollow(test_user_2)
    assert_not test_user.following?(test_user_2)
  end

  test "feed should have the right posts" do
    user = users(:test_user)
    user2 = users(:test_user_2)
    user3 = users(:seed_user_3)
    user.follow(user2)

    # with following user posts
    user2.microposts.each do |post_following|
      assert user.feed.include?(post_following)
    end

    # with my posts
    user.microposts.each do |post_following|
      assert user.feed.include?(post_following)
    end

    # unfollowing user posts
    user3.microposts.each do |post_following|
      assert_not user.feed.include?(post_following)
    end
  end

  test "should return true if the current user liked the post" do
    @post = microposts(:orange)
    @user.like(@post)
    assert @user.liking?(@post)
  end

  test "should return false if the current user did not like the post" do
    @post = microposts(:orange)
    assert_not @user.liking?(@post)
  end
end
