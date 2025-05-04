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

    trait :admin do
      admin { true }
    end

    trait :activated do
      activated { true }
    end

    trait :inactivated do
      activated { false }
    end

    trait :account_activation do
      account_activation { association :account_activation }
    end

    factory :admin_user, traits: [ :admin, :activated, :account_activation ]
    factory :activate_user, traits: [ :activated, :account_activation ]
    factory :inactivate_user, traits: [ :inactivated, :account_activation ]
  end

  factory :micropost do
    title { "title" }
    content { "content" }
    created_at { 10.minutes.ago }
    user
  end

  factory :account_activation do
    activated_at { Time.zone.now }
    activation_digest { AccountActivation.digest('token') }
    user
  end

  factory :password_reset do
    reset_digest { PasswordReset.digest('password') }
    reset_sent_at { Time.zone.now }
    user
  end
end

def user_with_posts(posts_count: 5, user: nil)
  user ||= FactoryBot.create(:activate_user)

  user.tap do |u|
    FactoryBot.create_list(:micropost, posts_count, user: u)
  end
end

def user_with_password_reset(user: nil)
  user ||= FactoryBot.create(:activate_user)

  user.tap do |u|
    FactoryBot.create(:password_reset, user: u)
  end
end
