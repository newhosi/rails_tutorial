# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :text
#  picture    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_microposts_on_user_id                 (user_id)
#  index_microposts_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Micropost, type: :model do
  include TestHelpers

  let!(:user) { create(:user) }
  let!(:micropost) { create(:micropost, user: user) }

  describe "validaitons" do
    it "is valid" do
      expect(micropost).to be_valid
    end

    it "requires a user_id" do
      micropost.user_id = nil
      expect(micropost).not_to be_valid
    end

    it "requires non-blank content" do
      micropost.content = " "
      expect(micropost).not_to be_valid
    end

    it "rejects content that is too long" do
      micropost.content = "a" * 141
      expect(micropost).not_to be_valid
    end

    it "accepts content that is 140 characters long" do
      micropost.content = "a" * 140
      expect(micropost).to be_valid
    end

    it "accepts a picture" do
      micropost.picture = fixture_file_upload('spec/image/kitten.jpg', 'image/png')
      expect(micropost).to be_valid
    end
  end
end
