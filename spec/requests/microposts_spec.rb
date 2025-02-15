require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  describe "POST /microposts" do
    context "when not logged in" do
      it "should redirect to login url" do
        expect do
          post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
        end.not_to change(Micropost, :count)
        expect(response).to redirect_to(login_url)
      end
    end

    context "when logged in" do
      it "should create a micropost" do
        log_in_as(create(:activate_user))
        expect do
          post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
        end.to change(Micropost, :count).by(1)
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "DELETE /microposts/:id" do
    context "when not logged in" do
      let!(:micropost) { create(:micropost) }
      it "should redirect to login url" do
        expect do
          delete micropost_path(micropost)
        end.not_to change(Micropost, :count)
        expect(response).to redirect_to(login_url)
      end
    end

    context "when logged in" do
      let!(:user) { create(:activate_user) }

      before do
        log_in_as(user)
      end

      it "should not delete other user's micropost" do
        micropost = create(:micropost)
        expect do
          delete micropost_path(micropost)
        end.not_to change(Micropost, :count)
        expect(response).to redirect_to(root_url)
      end

      it "should delete own micropost" do
        expect do
          micropost = create(:micropost, user: user)
          delete micropost_path(micropost)
        end.not_to change(Micropost, :count)
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
