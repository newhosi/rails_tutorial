require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  let!(:user) { create(:activate_user) }
  let!(:other_user) { create(:activate_user) }

  describe "POST /relationships" do
    context "when user is logged in" do
      it "should follow the user" do
        log_in_as(user)
        post relationships_path(other_user)
        expect(response.body).to include("Unfollow")
        expect(response.body).to include("1")
      end
    end

    context "when user is not logged in" do
      it "should redirect to login page" do
        post relationships_path(other_user)
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe "GET /relationships/:id" do
    context "when user is logged in" do
      it "should unfollow the user" do
        log_in_as(user)
        delete relationship_path(other_user)
        expect(response.body).to include("Follow")
        expect(response.body).to include("0")
      end
    end

    context "when user is not logged in" do
      it "should redirect to login page" do
        delete relationship_path(other_user)
        expect(response).to redirect_to(login_url)
      end
    end
  end
end
