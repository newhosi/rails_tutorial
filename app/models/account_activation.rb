# == Schema Information
#
# Table name: account_activations
#
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
  include TokenAuthenticatable

  self.primary_key = "user_id"
  belongs_to :user

  def activate
    update_columns(activated_at: Time.zone.now)
  end
end
