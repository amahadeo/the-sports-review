class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = current_user.comments.build(comment_params)
    @comment.article = @article
    
    if @comment.save
      redirect_to @article, notice: "Thanks for the comment!"
    else
      redirect_to @article, error: "Something's wrong with that comment. Please try again."
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @article = Article.find(params[:article_id])
    
    if @comment.destroy
      redirect_to @article, alert: "Comment was removed."
    else
      redirect_to @article, error: "There was a problem deleting that comment. Please try again"
    end
  end
    
  private
  
  def comment_params
    params.require(:comment).permit(:body)
  end
end
