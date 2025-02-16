class UsersController < ApplicationController
  before_action :logged_in_user, only: [ :index, :edit, :update, :destroy, :followers, :following ]
  before_action :correct_user,   only: [ :edit, :update ]
  before_action :admin_user,     only: [ :destroy ]

  def show
    @user = User.find(params[:id])
    @pagy, @microposts = pagy(@user.microposts)
    redirect_to root_url and return unless @user.account_activation.activated?
  end

  def index
    @pagy, @users = pagy(User.joins(:account_activation).where(account_activations: { activated: true }))
  end

  def new
    @user = User.new
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following
    @pagy, @users_pagy = pagy(@user.following)
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers
    @pagy, @users_pagy = pagy(@user.followers)
    render "show_follow"
  end

  def create
    @user = User.new(user_params)
    ActiveRecord::Base.transaction do
      @user.create_with_activation
      @user.send_activation_email
    end
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :password,
                                   :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
