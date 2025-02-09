class User < ApplicationRecord
  include TokenGeneratable

  has_many :microposts, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :post_likes, dependent: :destroy
  has_many :liked_posts, through: :post_likes, source: :micropost

  has_one :account_activation, dependent: :destroy

  has_many :password_resets, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  attr_accessor :remember_token, :activation_token
  has_secure_password

  before_save :downcase_email

  validates :name,
            presence: true,
            length: { maximum: 50 }

  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  validates :password,
             presence: true,
             length: { minimum: 6 },
             allow_nil: true

  def remember
    self.remember_token = self.class.new_token
    update_attribute(:remember_digest, self.class.digest(remember_token))
  end

  def create_with_activation
    self.activation_token = self.class.new_token
    digest = self.class.digest(activation_token)
    build_account_activation(activation_digest: digest, activated: false)
    save!
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def like(post)
    liked_posts << post
  end

  def unlike(post)
    post_likes.find_by(micropost_id: post.id, user_id: id).destroy
  end

  def liking?(post)
    liked_posts.include?(post)
  end

  def latest_password_reset
    password_resets.order(reset_sent_at: :desc).first
  end

  private
    def downcase_email
      self.email.downcase!
    end
end
