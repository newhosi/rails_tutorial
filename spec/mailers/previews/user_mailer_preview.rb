# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  user = User.first
  user.account_activation.activation_token = User.new_token
  UserMailer.account_activation(user)
end
