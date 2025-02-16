require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /" do
    context "when the user is not logged in" do
      it "renders the non_logged_in_home template" do
        get root_url
        expect(assigns(:feed_items)).to be_nil
        expect(response).to render_template(:home)
      end
    end

    context "when the user is logged in" do
      let!(:user) { create(:activate_user) }
      it "renders the logged_in_home template" do
        log_in_as(user)
        user_with_posts(posts_count: 5, user: user)
        get root_url
        expect(assigns(:feed_items).count).to eq(5)
        expect(response).to render_template(:home)
      end
    end
  end

  describe "GET /help" do
    it "renders the help template" do
      get help_url
      expect(response).to render_template(:help)
    end
  end

  describe "GET /about" do
    it "renders the about template" do
      get about_url
      expect(response).to render_template(:about)
    end
  end

  describe "GET /contact" do
    it "renders the contact template" do
      get contact_url
      expect(response).to render_template(:contact)
    end
  end
end
