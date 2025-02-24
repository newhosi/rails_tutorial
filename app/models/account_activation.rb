# == Schema Information
#
# Table name: account_activations
#
#  activated         :boolean          default(FALSE), not null
#  activated_at      :datetime
#  activation_digest :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :integer          not null, primary key
#
# Indexes
#
#  index_account_activations_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class AccountActivation < ApplicationRecord
  include TokenGeneratable

  self.primary_key = "user_id"
  belongs_to :user

  def authenticated?(token)
    digest = send("activation_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
end
