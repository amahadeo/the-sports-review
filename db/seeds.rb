require 'faker'

# Create Users
12.times do 
  user = User.new(
    username:          Faker::Internet.user_name,
    email:             Faker::Internet.safe_email,
    password:          "123456789",
    remote_avatar_url: Faker::Avatar.image
    )
  user.skip_confirmation!
  user.save!
end

member = User.new(
  username:           "tsruser",
  email:              "member@tsr.com",
  password:           "123456789",
  remote_avatar_url:  Faker::Avatar.image
  )
member.skip_confirmation!
member.save

users = User.all

# Create Articles
75.times do 
  article = Article.create!(
    title:    Faker::Team.name,
    body:     Faker::Hipster.paragraph,
    user:     users.sample
    )
  article.update_attributes(created_at: rand(10.minutes .. 15.days).ago)
end

articles = Article.all

# Create Comments
800.times do
  comment = Comment.create!(
    body:     Faker::StarWars.quote,
    user:     users.sample,
    article:  articles.sample,
    )
  comment.update_attributes(created_at: rand(10.minutes .. 15.days).ago)
end

# Create Votes
300.times do
  articles.sample.upvote_by users.sample
end

# Create Follows/Relationships
125.times do
  user1 = users.sample
  user2 = users.sample
  user1.follow(user2) unless ((user1 == user2) || user1.following?(user2))
end

articles.each do |article|
  article.update_ranks
end

users.each do |user|
  user.update_ranks
end

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Article.count} articles created"
puts "#{Comment.count} comments created"
puts "#{Relationship.count} relationships created"
puts "#{ActsAsVotable::Vote.count} votes created"