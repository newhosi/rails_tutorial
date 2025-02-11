# https://github.com/thoughtbot/factory_bot/blob/main/GETTING_STARTED.md#rspec
FactoryBot.define do
  factory :relationship do
  end

  factory :post_like do
    like_at { Time.zone.now }
  end

  factory :user do
    name { "user" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password_digest { User.digest('password') }
    admin { false }
  end

  factory :admin_user, parent: :user do
    admin { true }
  end

  factory :micropost do
    content { "content" }
    created_at { 10.minutes.ago }
    user
  end

  factory :password_reset do
    reset_digest { PasswordReset.digest('password') }
    reset_sent_at { Time.zone.now }
    user
  end
end

def user_with_posts(posts_count: 5)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:micropost, posts_count, user: user)
  end
end
