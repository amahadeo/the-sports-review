class RelationshipsController < ApplicationController
  def create
    authorize Relationship
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    @user.update_ranks
    
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
  def destroy
    authorize Relationship
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    @user.update_ranks
    
    
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
