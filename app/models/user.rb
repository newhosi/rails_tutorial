class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name,
            presence: true,
            length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password # 가상의 password 와 password_confirmation 속성에 대한 검증 테스트를 추가하고 있음.
  validates :password, presence: true, length: { minimum: 6 }
end
