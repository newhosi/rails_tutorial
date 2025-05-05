class BookmarksController < ApplicationController
  def create
    @post = Micropost.find(params[:micropost_id])
    current_user.bookmark(@post)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_path(current_user) }
    end
  end

  def destroy
    @post = Micropost.find(params[:micropost_id])
    current_user.unbookmark(@post)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_path(current_user) }
    end
  end
end
