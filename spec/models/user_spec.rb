require 'rails_helper'

RSpec.describe User, type: :model do
  include TestHelpers

  describe "validations" do
    context "is valid" do
      let(:user) { build(:user) }
      specify "with a name, email, and password" do
        expect(user).to be_valid
      end
    end

    context "is invalid" do
      let(:user) { build(:user) }

      example "name is nil" do
        user.name = nil
        expect(user).not_to be_valid
      end

      example "name is too long" do
        user.name = "a" * 51
        expect(user).not_to be_valid
      end

      example "email is nil" do
        user.email = nil
        expect(user).not_to be_valid
      end

      example "email is too long" do
        user.email = "a" * 244 + "@example.com"
        expect(user).not_to be_valid
      end

      example "email does not match the regex" do
        invalid_emails = [
          "user@example,com",
          "user_at_example.com",
          "user.name@example.",
          "user@ex+ample.com",
          "user@example..com"
        ]
        invalid_emails.each do |invalid_email|
          user.email = invalid_email
          expect(user).not_to be_valid
        end
      end

      example "email is not unique" do
        user.save
        duplicate_user = user.dup
        expect(duplicate_user).not_to be_valid
      end

      example "password is nil" do
        user.password = nil
        expect(user).not_to be_valid
      end

      example "password is too short" do
        user.password = "a" * 5
        expect(user).not_to be_valid
      end
    end
  end

  describe "#create_with_activation" do
    let(:user) { build(:user) }

    it "creates an account activation" do
      user.create_with_activation
      expect(user.account_activation).to be_present
    end
  end

  describe "#feed" do
    let!(:user) { user_with_posts(posts_count: 5) }
    specify "has 5 posts" do
      expect(user.feed.length).to eq(5)
    end
  end

  describe "#follow" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    specify "user has one follower" do
      other_user.follow(user)
      expect(user.followers.length).to eq(1)
    end
  end

  describe "#unfollow" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    specify "user has no followers" do
      pending "using turbo with remote execution, so additional test logic is required."
      other_user.follow(user)
      expect(user.followers.length).to eq(1)
      other_user.unfollow(user)
      expect(user.followers.length).to eq(0)
    end
  end

  describe "#following?" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    specify "user is following other_user" do
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy
    end
  end

  describe "#like" do
    let!(:user) { create(:user) }
    let!(:post) { create(:micropost) }
    specify "user has one liked post" do
      user.like(post)
      expect(user.liked_posts.length).to eq(1)
    end
  end

  describe "#unlike" do
    let!(:user) { create(:user) }
    let!(:post) { create(:micropost) }
    specify "user has no liked posts" do
      pending "using turbo with remote execution, so additional test logic is required."
      user.like(post)
      expect(user.liked_posts.length).to eq(1)
      user.unlike(post)
      expect(user.liked_posts.length).to eq(0)
    end
  end

  describe "#liking?" do
    let!(:user) { create(:user) }
    let!(:post) { create(:micropost) }
    specify "user is liking post" do
      user.like(post)
      expect(user.liking?(post)).to be_truthy
    end
  end
end
