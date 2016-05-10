class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
    @comments = @article.comments
    #@new_comment = @article.comments.new
  end

  def new
    @article = Article.new
  end
  
  def create
    @article = current_user.articles.build(article_params)
    
    if @article.save
      redirect_to @article, notice: "Thanks for contributing!"
    else
      flash[:error] = "Darn it! Something's wrong with that article, please try again."
      render :new
    end
  end

  def edit
    @article = Article.find(params[:id])
  end
  
  def update
    @article = Article.find(params[:id])
    
    if @article.update_attributes(article_params)
      redirect_to @article, notice: "Update saved. Thanks for contributing!"
    else
      flash[:error] = "Darn it! Something's wrong with that article, please try again."
      render :edit
    end
  end
  
  def destroy
    @article = Article.find(params[:id])
    
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
