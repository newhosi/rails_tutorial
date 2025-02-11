class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [ :edit, :update ]
  before_action :valid_user,       only: [ :edit, :update ]
  before_action :check_expiration, only: [ :edit, :update ]

  def new
  end

  def edit
  end

  def create
    ActiveRecord::Base.transaction do
      @user = User.find_by!(email: params[:password_reset][:email].downcase)
      password_reset = PasswordReset.build_for(@user)
      password_reset.save!
      password_reset.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    end
  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Email address not found."
    render "new"
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render "edit"
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render "edit"
    end
  end

  def user_params
    params.require(:user).permit(:password,
                                 :password_confirmation)
  end

  private
    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      unless @user && @user.account_activation.activated? && @user.password_resets.latest.first.authenticated?(params[:id])
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_resets.latest.first.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_path
      end
    end
end
