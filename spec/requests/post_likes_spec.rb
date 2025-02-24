require 'rails_helper'

RSpec.describe "PostLikes", type: :request do
  let!(:user) { user_with_posts(posts_count: 1) }
  describe "POST /microposts/:micropost_id/likes" do
    context "when user is logged in" do
      it "likes the post" do
        log_in_as(user)
        post micropost_likes_path(user.microposts.first.id)
        expect(user.liking?(user.microposts.first)).to be_truthy
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is not logged in" do
      it "redirects to login page" do
        post micropost_likes_path(user.microposts.first.id)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "DELETE /microposts/:micropost_id/likes" do
    context "when user is logged in" do
      it "unlikes the post" do
        log_in_as(user)
        post micropost_likes_path(user.microposts.first.id)
        delete micropost_like_path(user.microposts.first.id)
        expect(user.liking?(user.microposts.first)).to be_falsey
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is not logged in" do
      it "redirects to login page" do
        delete micropost_likes_path(user.microposts.first.id)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
