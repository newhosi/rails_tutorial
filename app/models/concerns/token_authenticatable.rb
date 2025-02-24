module TokenAuthenticatable
  extend ActiveSupport::Concern

  included do
    def authenticated?(type, token)
      digest = send(type)
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end
  end

  class_methods do
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
