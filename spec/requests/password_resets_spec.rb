require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  describe "POST /password_resets" do
    context "when email address is not found" do
      let!(:user) { build(:user) }
      it "should render new page" do
        post password_resets_path, params: { password_reset: { email: user.email } }

        expect(response).to render_template(:new)
        expect(response.body).to include("Email address not found.")
      end
    end

    context "when password reset request success" do
      let!(:user) { create(:activate_user) }
      it "should render root page" do
        expect {
          post password_resets_path, params: { password_reset: { email: user.email } }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
        expect(user.reload.password_resets.count).to eq(1)
        expect(response).to redirect_to(:root)
        follow_redirect!
        expect(response.body).to include("Email sent with password reset instructions.")
      end
    end
  end

  describe "GET /password_resets/:id/edit" do
    context "when email address is not found" do
      let!(:user) { create(:activate_user) }
      it "should render root page" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user.password_resets[0].reset_token = "password"

        get edit_password_reset_path(user.password_resets[0].reset_token, "invalid")

        expect(response).to redirect_to(:root)
      end
    end

    context "when user is invalid" do
      let!(:user) { create(:inactivate_user) }
      it "should render root page" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user.password_resets[0].reset_token = "password"

        get edit_password_reset_path(user.password_resets[0].reset_token, "invalid")

        expect(response).to redirect_to(:root)
      end
    end

    context "when password reset token invalid" do
      let!(:user) { create(:activate_user) }
      it "should render root page" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user.password_resets[0].reset_token = "password"

        get edit_password_reset_path(user.password_resets[0].reset_token, "invalid")

        expect(response).to redirect_to(:root)
      end
    end

    context "when password reset exipred" do
      let!(:user) { user_with_password_reset }
      it "should render new password reset page" do
        user.password_resets[0].reset_token = "password"
        reset_token = user.password_resets[0].reset_token
        user.password_resets[0].update_attribute!(:reset_sent_at, 3.hours.ago)

        get edit_password_reset_path(id: reset_token, email: user.email)

        expect(response).to redirect_to(:new_password_reset)
        follow_redirect!
        expect(response.body).to include("Password reset has expired.")
      end
    end
  end

  describe "PUT /password_resets/:id" do
    context "when email address is not found" do
    let!(:user) { create(:activate_user) }
      it "should render root page" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user.password_resets[0].reset_token = "password"

        put password_reset_path(user.password_resets[0].reset_token, "invalid"),
          params: { user: { password: "password", password_confirmation: "password" } }

        expect(response).to redirect_to(:root)
      end
    end

    context "when user is invalid" do
      let!(:user) { create(:inactivate_user) }
      it "should render root page" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user.password_resets[0].reset_token = "password"

        put password_reset_path(user.password_resets[0].reset_token, "invalid"),
          params: { user: { password: "password", password_confirmation: "password" } }

        expect(response).to redirect_to(:root)
      end
    end

    context "when password reset token invalid" do
      let!(:user) { create(:activate_user) }
      it "should render root page" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user.password_resets[0].reset_token = "password"

        put password_reset_path(id: "invalid", email: user.email),
          params: { user: { password: "password", password_confirmation: "password" } }

        expect(response).to redirect_to(:root)
      end
    end

    context "when password reset exipred" do
      let!(:user) { user_with_password_reset }
      it "should render new password reset page" do
        user.password_resets[0].reset_token = "password"
        reset_token = user.password_resets[0].reset_token
        user.password_resets[0].update_attribute!(:reset_sent_at, 3.hours.ago)

        put password_reset_path(id: reset_token, email: user.email),
          params: { user: { password: "password", password_confirmation: "password" } }

        expect(response).to redirect_to(:new_password_reset)
        follow_redirect!
        expect(response.body).to include("Password reset has expired.")
      end
    end

    context "when password reset success" do
      let!(:user) { user_with_password_reset }
      it "should render new password reset page" do
        user.password_resets[0].reset_token = "password"

        put password_reset_path(id: "password", email: user.email),
          params: { user: { password: "password", password_confirmation: "password" } }

        expect(response).to redirect_to(user)
        follow_redirect!
        expect(response.body).to include("Password has been reset.")
      end
    end
  end
end
