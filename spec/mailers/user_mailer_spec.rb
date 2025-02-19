require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let!(:user) { create(:inactivate_user) }
    let!(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      user.activation_token = User.new_token
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([ user.email ])
    end

    it "renders the body" do
    end
  end
end
