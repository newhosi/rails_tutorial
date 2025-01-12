# users
User.create!(name:                  "example-user",
             email:                 "example-user@example.com",
             password:              "password",
             password_confirmation: "password",
             admin:                 true,
             activated:             true,
             activated_at:          Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@example.com"
  password = "password"
  user = User.create!(
    name:                  name,
    email:                 email,
    password:              password,
    password_confirmation: password,
    activated:             true,
    activated_at:          Time.zone.now)
  3.times do |n|
    # microposts
    user.microposts.create!(
      content: Faker::Lorem.sentence(word_count: 5)
    )
  end
end

# relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
