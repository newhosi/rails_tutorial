require 'rails_helper'

RSpec.describe PasswordReset, type: :model do
  include TestHelpers

  describe "#authenticated?" do
    let!(:password_reset) { PasswordReset.new(reset_digest: digest("token")) }

    it "returns true if the given string matches the digest" do
      expect(password_reset.authenticated?("token")).to be_truthy
    end

    it "returns false if the given string does not match the digest" do
      expect(password_reset.authenticated?("invalid_token")).to be_falsey
    end
  end

  describe "#password_reset_expired?" do
    let(:password_reset) { PasswordReset.new(reset_sent_at: time) }

    context "returns true if the reset sent at is more than 2 hours ago" do
      let(:time) { 3.hours.ago }
      specify "false" do
        expect(password_reset.password_reset_expired?).to be_truthy
      end
    end

    context "returns false if the reset sent at is less than 2 hours ago" do
      let(:time) { 1.hours.ago }
      specify "true" do
        expect(password_reset.password_reset_expired?).to be_falsey
      end
    end
  end
end
