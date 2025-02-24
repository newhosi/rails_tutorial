# == Schema Information
#
# Table name: post_likes
#
#  like_at      :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  micropost_id :integer          not null, primary key
#  user_id      :integer          not null, primary key
#
# Indexes
#
#  index_post_likes_on_micropost_id  (micropost_id)
#  index_post_likes_on_user_id       (user_id)
#
# Foreign Keys
#
#  micropost_id  (micropost_id => microposts.id)
#  user_id       (user_id => users.id)
#
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
