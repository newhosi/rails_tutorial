# == Schema Information
#
# Table name: account_activations
#
#  activated_at      :datetime
#  activation_digest :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :bigint           not null, primary key
#
# Indexes
#
#  index_account_activations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe AccountActivation, type: :model do
  include TestHelpers

  describe "#authenticated?" do
    let!(:account_activation) { AccountActivation.new(activation_digest: digest("token")) }

    it "returns true if the given token matches the digest" do
      expect(account_activation.authenticated?("activation_digest", "token")).to be_truthy
    end

    it "returns false if the given token does not match the digest" do
      expect(account_activation.authenticated?("activation_digest", "wrong_token")).to be_falsey
    end
  end
end
