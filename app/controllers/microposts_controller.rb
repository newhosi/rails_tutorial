class MicropostsController < ApplicationController
  before_action :logged_in_user, :activated_user, only: [ :create, :destroy ]
  before_action :correct_user, :activated_user, only: [ :destroy ]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost && @micropost.save
      flash[:success] = "micropost created!"
      redirect_to current_user
    else
      @pagy, @feed_items = pagy(current_user.feed)
      if @feed_items.empty?
        @feed_items = []
      end
      flash[:danger] = "Failed to create micropost."
      redirect_to current_user
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_back(fallback_location: root_url)
  end

  private
    def micropost_params
      params.require(:micropost).permit(:title, :content, :picture)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
