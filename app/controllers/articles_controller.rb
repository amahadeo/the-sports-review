class ArticlesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :feed_index, :upvote, :downvote]
  
  def index
    if params[:search].present?
      @articles = Article.search(params[:search]).records
    else
      @articles = Article.order("top_rank DESC")
    end
    authorize Article
  end
  
  def feed_index
    authorize Article
    @articles = current_user.feed
  end

  def newest_index
    @articles = Article.order("created_at DESC")
    authorize Article
  end
  
  def trend_index
    @articles = Article.order("trend_rank DESC")
    authorize Article
  end
  
  def show
    @article = Article.find(params[:id])
    @comments = @article.comments
    authorize @article
  end

  def new
    @article = Article.new
    authorize @article
  end
  
  def create
    @article = current_user.articles.build(article_params)
    authorize @article
    
    if @article.save
      @article.update_ranks
      current_user.update_ranks
      redirect_to @article, notice: "Thanks for contributing!"
    else
      flash[:error] = "Darn it! Something's wrong with that article, please try again."
      render :new
    end
  end

  def edit
    @article = Article.find(params[:id])
    authorize @article
  end
  
  def update
    @article = Article.find(params[:id])
    authorize @article
    
    if @article.update_attributes(article_params)
      redirect_to @article, notice: "Update saved. Thanks for contributing!"
    else
      flash[:error] = "Darn it! Something's wrong with that article, please try again."
      render :edit
    end
  end
  
  def destroy
    @article = Article.find(params[:id])
    authorize @article
    
    if @article.destroy
      current_user.update_ranks
      redirect_to articles_path, notice: "Article deleted."
    else
      flash[:error] = "Sorry, there was an error deleting that article."
      render :back    
    end
  end 
  
  def upvote
    @article = Article.find(params[:id])
    authorize @article
    @article.upvote_by current_user
    @article.update_ranks
    @article.user.update_ranks
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
  
  def downvote
    @article = Article.find(params[:id])
    authorize @article
    @article.downvote_by current_user
    @article.update_ranks
    @article.user.update_ranks
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
  
  private
  
  def article_params
    params.require(:article).permit(:title, :body)
  end
  
  def logged_in_user
    redirect_to new_user_session_path, status: :see_other, alert: "Please log in first." unless current_user
  end
end
