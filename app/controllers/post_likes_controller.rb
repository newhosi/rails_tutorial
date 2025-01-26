class PostLikesController < ApplicationController
  before_action :logged_in_user, only: [ :create, :destroy ]

  def create
    @post = Micropost.find(params[:micropost_id])
    current_user.like(@post)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  def destroy
    @post = Micropost.find(params[:micropost_id])
    current_user.unlike(@post)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end
end
