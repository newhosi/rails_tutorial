# Preview all emails at http://localhost:3000/rails/mailers/password_resets_mailer
class PasswordResetMailerPreview < ActionMailer::Preview
  password_reset = PasswordReset.build_for(User.first)
  password_reset.reset_token = PasswordReset.new_token
  PasswordResetMailer.password_reset(password_reset)
end
