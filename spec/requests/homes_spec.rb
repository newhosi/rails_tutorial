require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /" do
    context "when the user is not logged in" do
      it "renders the non_logged_in_home template" do
        get root_url
        # expect(assigns(:microposts)).to be_nil
        expect(response).to render_template(:home)
      end
    end

    context "when the user is logged in" do
      let!(:user) { create(:activate_user) }
      it "renders the logged_in_home template" do
        log_in_as(user)
        user_with_posts(posts_count: 5, user: user)
        get root_url
        expect(assigns(:microposts).count).to eq(5)
        expect(response).to render_template(:home)
      end
    end
  end
end
