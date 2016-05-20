require 'faker'

# Create Users
5.times do 
  user = User.new(
    username:   Faker::Internet.user_name,
    email:      Faker::Internet.safe_email,
    password:   "123456789"
    )
  user.skip_confirmation!
  user.save!
end

member = User.new(
  username:   "tsruser",
  email:      "member@tsr.com",
  password:   "123456789"
  )
member.skip_confirmation!
member.save

users = User.all

# Create Articles
50.times do 
  Article.create!(
    title:    Faker::Team.name,
    body:     Faker::Hipster.paragraph,
    user:     users.sample
    )
end

articles = Article.all

# Create Comments
800.times do
  Comment.create!(
    body:     Faker::StarWars.quote,
    user:     users.sample,
    article:  articles.sample,
    )
end

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Article.count} articles created"
puts "#{Comment.count} comments created"