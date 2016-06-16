class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
         
  validates :username, presence: true, uniqueness: true
  
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships
  acts_as_voter
  mount_uploader :avatar, AvatarUploader
  
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
  
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  
  def following?(other_user)
    following.include?(other_user)
  end
  
  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Article.where("user_id IN (#{following_ids})", user_id: id)
  end
  
  def update_ranks
    total_votes_score = articles.sum(:cached_votes_score)
    
    recent_votes_score = articles.sum(:trend_rank) # article trend_ranks are also cached recent vote scores
    recent_followers = passive_relationships.where("created_at >= ?", Time.now - 3.days).count
    recent_articles = articles.where("created_at >= ?", Time.now - 4.days).count
    recent_comments = comments.where("created_at >= ?", Time.now - 3.days).count
    
    new_top_rank = passive_relationships.count + articles.count + comments.count + total_votes_score
    new_trend_rank = recent_followers + recent_articles + recent_comments + recent_votes_score
    
    update_attributes(top_rank: new_top_rank, trend_rank: new_trend_rank)
  end
end
