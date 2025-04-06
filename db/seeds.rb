# users
admin = User.new(
             name:                  "admin",
             email:                 "admin@example.com",
             password:              "password",
             password_confirmation: "password",
             admin:                 true,
             activated:             true)

admin.build_account_activation(activated_at: Time.zone.now)
admin.save!

49.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@example.com"
  password = "password"
  user = User.new(
    name:                  name,
    email:                 email,
    password:              password,
    password_confirmation: password,
    activated:             true)
  user.build_account_activation(activated_at: Time.zone.now)
  user.save!

  3.times do |n|
    # microposts
    user.microposts.create!(
      title: Faker::Lorem.sentence(word_count: 3),
      content: Faker::Lorem.paragraph(sentence_count: 5)
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
