require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  def setup
    @user = users(:test_user)
  end

  test "account_activation" do
    mail = UserMailer.account_activation(@user)
    @user.activation_token = User.new_token
    assert_equal "Account activation", mail.subject
    assert_equal [ @user.email ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match @user.name, mail.body.encoded
    assert_match @user.activation_token, mail.body.encoded
    assert_match CGI.escape(@user.email), mail.body.encoded
  end

  test "password_reset" do
    mail = UserMailer.password_reset(@user)
    @user.reset_token = User.new_token
    assert_equal "Password reset", mail.subject
    assert_equal [ @user.email ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match @user.reset_token, mail.body.encoded
    assert_match CGI.escape(@user.email), mail.body.encoded
  end
end
