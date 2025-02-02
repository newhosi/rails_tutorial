class PasswordResetMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.password_reset_mailer.password_reset.subject
  #
  def password_reset(password_reset)
    @password_reset = password_reset
    @user = password_reset.user
    mail to: @user.email,
         subject: "Password reset"
  end
end
