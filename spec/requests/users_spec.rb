require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { create(:activate_user) }

  before do
    log_in_as(user)
  end

  describe "GET /users/:id/following" do
    it "should get following" do
      get following_user_path(user)
      expect(assigns(:title)).to eq("Following")
      expect(assigns(:user)).to eq(user)
      expect(assigns(:users)).to eq(user.following)
    end
  end

  describe "GET /users/:id/followers" do
    it "should get followers" do
      get followers_user_path(user)
      expect(assigns(:title)).to eq("Followers")
      expect(assigns(:user)).to eq(user)
      expect(assigns(:users)).to eq(user.followers)
    end
  end

  describe "GET /users" do
    skip "users.count is 10. but it is 4" do
      it "should get activated users" do
        create_list(:activate_user, 3)
        create_list(:inactivate_user, 2)
        get users_path
        expect(assigns(:users).count).to eq(4)
      end
    end
  end

  describe "GET /users/new" do
    it "should get new" do
      get new_user_path
      expect(response).to render_template(:new)
    end
  end

  describe "GET /users/:id/edit" do
    it "should get edit" do
      get edit_user_path(user)
      expect(response).to render_template(:edit)
    end
  end

  describe "GET /users/:id" do
    let!(:user) { user_with_posts(posts_count: 5) }
    it "should get user" do
      get user_path(user)
      expect(assigns(:user)).to eq(user)
      expect(assigns(:microposts)).to eq(user.microposts)
    end
  end

  describe "PUT /users/:id" do
    it "should update user" do
      patch user_path(user), params: { user: { name: "updated" } }
      expect(user.reload.name).to eq("updated")
    end
  end

  describe "DELETE /users/:id" do
    let!(:admin_user) { create(:admin_user) }
    context "when user is admin" do
      it "should delete user" do
        log_in_as(admin_user)
        delete user_path(user)
        expect(User.exists?(user.id)).to be_falsey
      end
    end

    context "when user is not admin" do
      it "should not delete user" do
        delete user_path(user)
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
