# == Schema Information
#
# Table name: password_resets
#
#  id            :bigint           not null, primary key
#  reset_digest  :string(255)      not null
#  reset_sent_at :datetime         not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_password_resets_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class PasswordReset < ApplicationRecord
  include TokenAuthenticatable

  belongs_to :user

  scope :latest, -> { order(reset_sent_at: :desc) }

  attr_accessor :reset_token

  def create_reset_digest
    self.reset_token = self.class.new_token
    self.reset_digest = self.class.digest(reset_token)
  end

  def send_password_reset_email
    PasswordResetMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
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
