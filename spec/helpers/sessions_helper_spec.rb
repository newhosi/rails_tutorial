require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionHelper. For example:
#
# describe SessionHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, type: :helper do
  let!(:user) { create(:activate_user) }
  describe "#log_in" do
    it "logs in user" do
      helper.log_in(user)
      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe "#remember" do
    it "remembers user" do
      helper.remember(user)
      expect(cookies.permanent.signed[:user_id]).to eq(user.id)
      expect(cookies.permanent[:remember_token]).to eq(user.remember_token)
      expect(user.reload.remember_digest).to_not be_nil
    end
  end

  describe "#current_user" do
    context "when session is not nil" do
      it "returns current user" do
        helper.log_in(user)
        expect(helper.current_user).to eq(user)
      end
    end

    context "when cookies is not nil" do
      it "returns current user" do
        user.update_attribute!(:remember_digest, User.digest(User.new_token))
        helper.remember(user)
        expect(helper.current_user).to eq(user)
      end
    end
  end

  describe "#current_user?" do
    it "returns true if user is current user" do
      helper.log_in(user)
      expect(helper.current_user?(user)).to be_truthy
    end

    it "returns false if user is not current user" do
      expect(helper.current_user?(user)).to be_falsey
    end
  end

  describe "#logged_in?" do
    it "returns true if user is logged in" do
      helper.log_in(user)
      expect(helper.logged_in?).to be_truthy
    end

    it "returns false if user is not logged in" do
      expect(helper.logged_in?).to be_falsey
    end
  end

  describe "#forget" do
    it "forgets user" do
      helper.remember(user)
      helper.forget(user)
      expect(cookies[:user_id]).to be_nil
      expect(cookies[:remember_token]).to be_nil
      expect(user.reload.remember_digest).to be_nil
    end
  end

  describe "#log_out" do
    it "logs out user" do
      helper.log_in(user)
      helper.log_out
      expect(session[:user_id]).to be_nil
      expect(helper.current_user).to be_nil
    end
  end
end
