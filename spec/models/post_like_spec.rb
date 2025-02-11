require 'rails_helper'

RSpec.describe PostLike, type: :model do
  describe "validations" do
    let!(:user) { create(:user) }
    let!(:micropost) { create(:micropost, user_id: user.id) }
    let!(:post_like) { build(:post_like, user_id: user.id, micropost_id: micropost.id) }

    it "is valid" do
      expect(post_like).to be_valid
    end

    it "is invalid without a user_id" do
      post_like.user_id = nil
      expect(post_like).not_to be_valid
    end

    it "is invalid without a micropost_id" do
      post_like.micropost_id = nil
      expect(post_like).not_to be_valid
    end
  end
end
