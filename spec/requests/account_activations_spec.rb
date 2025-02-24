require 'rails_helper'

RSpec.describe "AccountActivations", type: :request do
  describe "GET /account_activations/:id/edit" do
    context "when user inactivated" do
      let!(:user) { create(:inactivate_user) }
      it "should activated" do
        get edit_account_activation_path("token", email: user.email)
        expect(user.reload.activated).to be_truthy
        expect(response).to redirect_to(user)
      end
    end

    context "when user already activated" do
      let!(:user) { create(:activate_user) }
      it "should redirect to root url" do
        get edit_account_activation_path("token", email: user.email)
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
