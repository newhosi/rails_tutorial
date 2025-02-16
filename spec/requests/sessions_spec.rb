require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "renders the login page" do
      get login_path
      expect(response).to render_template(:new)
    end
  end

  describe "POST /login" do
    context "when user is activated" do
      let!(:user) { create(:activate_user) }
      it "logs in the user without remember me" do
        post login_path, params: { session: { email: user.email, password: "password", remember_me: 1 } }
        expect(session[:user_id]).to eq(user.id)
        expect(user.reload.remember_digest).to_not be_nil
        expect(response).to redirect_to(user)
      end

      it "logs in the user with remember me" do
        post login_path, params: { session: { email: user.email, password: "password" } }
        expect(session[:user_id]).to eq(user.id)
        expect(user.reload.remember_digest).to be_nil
        expect(response).to redirect_to(user)
      end
    end

    context "when user is not activated" do
      let!(:user) { create(:inactivate_user) }
      it "does not log in the user" do
        post login_path, params: { session: { email: user.email, password: user.password } }
        expect(session[:user_id]).to be_nil
        expect(response).to render_template(:new)
      end
    end

    context "when user is not found" do
      it "should render the login page" do
        post login_path, params: { session: { email: "invalid@example.com", password: "password" } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "DELETE /logout" do
    let (:user) { create(:activate_user) }
    context "when user is logged in" do
      it "logs out the user" do
        log_in_as(user)
        delete logout_path
        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(root_url)
      end
    end

    context "when user is not logged in" do
      it "redirects to root url" do
        delete logout_path
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
