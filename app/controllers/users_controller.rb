class UsersController < ApplicationController
  def index
    @top_users = User.order("top_rank DESC").take(12)
    @trending_users = User.order("trend_rank DESC").take(12)
  end

  def show
    @user = User.find(params[:id])
    @articles = @user.articles
    @comments = @user.comments
    @votes_score = @user.articles.sum(:cached_votes_score)
  end
  
end
