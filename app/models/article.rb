require 'elasticsearch/model'

class Article < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :user
  has_many :comments, dependent: :destroy
  acts_as_votable
  
  validates :title, length: { minimum: 5 }, presence: true, uniqueness: true
  validates :body, length: {minimum: 20 }, presence: true
  validates :user, presence: true
  
  def update_ranks
    age_in_days = (created_at - Time.new(1970,1,1)) / (60 * 60 * 24)
    new_top_rank = cached_votes_score + age_in_days

    recent_up_votes = get_upvotes.where("updated_at >= ?", Time.now - 2.days).size
    recent_down_votes = get_downvotes.where("updated_at >= ?", Time.now - 2.days).size
    new_trend_rank = recent_up_votes - recent_down_votes
    
    update_attributes(top_rank: new_top_rank, trend_rank: new_trend_rank)
  end
end

Article.import force: true
