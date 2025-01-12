require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path

    ## invalid posts
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select "div#error_explanation"

    ## valid posts
    content = "valid content"
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

    ## delete posts
    delete_micropost = @user.microposts.first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(delete_micropost)
    end

    ## access other user's delete
    get user_path(users(:test_user_2))
    assert_select "a[data-turbo-method=?][data-confirm=?]", "delete", "Are you sure?", count: 0
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body

    ## user with zero microposts
    test_user_2 = users(:test_user_2)
    log_in_as(test_user_2)
    get root_path
    assert_match "0 micropost", response.body
    test_user_2.microposts.create!(content: "add posts")
    get root_path
    assert_match "1 micropost", response.body
  end
end
