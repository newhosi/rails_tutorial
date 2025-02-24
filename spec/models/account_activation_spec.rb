require 'rails_helper'

RSpec.describe AccountActivation, type: :model do
  include TestHelpers

  describe "#authenticated?" do
    let!(:account_activation) { AccountActivation.new(activation_digest: digest("token")) }

    it "returns true if the given token matches the digest" do
      expect(account_activation.authenticated?("token")).to be_truthy
    end

    it "returns false if the given token does not match the digest" do
      expect(account_activation.authenticated?("wrong_token")).to be_falsey
    end
  end
end
