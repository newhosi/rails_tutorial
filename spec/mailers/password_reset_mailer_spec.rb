require "rails_helper"

RSpec.describe PasswordResetMailer, type: :mailer do
  describe "password_reset" do
    let!(:password_reset) { create(:password_reset) }
    let!(:mail) { PasswordResetMailer.password_reset(password_reset) }

    it "renders the headers" do
      password_reset.reset_token = PasswordReset.new_token
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq([ password_reset.user.email ])
    end

    it "renders the body" do
    end
  end
end
