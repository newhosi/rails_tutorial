require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe "validations" do
    let!(:follower) { create(:user) }
    let!(:followed) { create(:user) }
    let!(:relationship) { build(:relationship, follower_id: follower.id, followed_id: followed.id) }

    it "is valid" do
      expect(relationship).to be_valid
    end

    it "is invalid without a follower_id" do
      relationship.follower_id = nil
      expect(relationship).not_to be_valid
    end

    it "is invalid without a followed_id" do
      relationship.followed_id = nil
      expect(relationship).not_to be_valid
    end
  end
end
