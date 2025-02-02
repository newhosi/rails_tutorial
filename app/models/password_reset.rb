class PasswordReset < ApplicationRecord
  include TokenGeneratable

  belongs_to :user

  attr_accessor :reset_token

  def create_reset_digest
    self.reset_token = self.class.new_token
    self.reset_digest = self.class.digest(reset_token)
  end

  def send_password_reset_email
    PasswordResetMailer.password_reset(self).deliver_now
  end

  class << self
    def build_for(user)
      password_reset = new(
        user_id: user.id,
        reset_sent_at: Time.zone.now
      )
      password_reset.create_reset_digest
      password_reset
    end
  end
end
