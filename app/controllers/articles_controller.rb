class ArticlesController < ApplicationController
  def index
    if params[:search].present?
      @articles = Article.search(params[:search]).records
    else
      @articles = Article.all
    end
    authorize Article
  end

  def show
    @article = Article.find(params[:id])
    @comments = @article.comments
    authorize @article
  end

  def new
    redirect_to new_user_session_path, alert: "Please log in first." unless current_user
    @article = Article.new
    # authorize @article
  end
  
  def create
    @article = current_user.articles.build(article_params)
    authorize @article
    
    if @article.save
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
      redirect_to articles_path, notice: "Article deleted."
    else
      flash[:error] = "Sorry, there was an error deleting that article."
      render :back    
    end
  end 
  
  private
  
  def article_params
    params.require(:article).permit(:title, :body)
  end
end
