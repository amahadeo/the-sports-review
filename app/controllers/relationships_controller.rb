class RelationshipsController < ApplicationController
  def create
    authorize Relationship
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
  def destroy
    authorize Relationship
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
