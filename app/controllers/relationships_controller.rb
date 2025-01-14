class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    @followers = @user.followers
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @user }
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    @followers = @user.followers
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @user }
    end
  end
end
