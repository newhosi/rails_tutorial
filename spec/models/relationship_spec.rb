# == Schema Information
#
# Table name: relationships
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :bigint           not null
#  follower_id :bigint           not null
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (followed_id => users.id) ON DELETE => cascade
#  fk_rails_...  (follower_id => users.id) ON DELETE => cascade
#
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
