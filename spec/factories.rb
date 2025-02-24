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

    trait :activate do
      account_activation { association :account_activation, activated: true }
    end

    trait :inactivate do
      account_activation { association :account_activation, activated: false }
    end

    factory :admin_user, traits: [ :admin, :activate ]
    factory :activate_user, traits: [ :activate ]
    factory :inactivate_user, traits: [ :inactivate ]
  end

  factory :micropost do
    content { "content" }
    created_at { 10.minutes.ago }
    user
  end

  factory :account_activation do
    activated { true }
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
