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
