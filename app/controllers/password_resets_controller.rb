class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [ :edit, :update ]
  before_action :valid_user,       only: [ :edit, :update ]
  before_action :check_expiration, only: [ :edit, :update ]

  def new
  end

  def edit
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
      if @user
        ActiveRecord::Base.transaction do
          password_reset = PasswordReset.build_for(@user)
          password_reset.save!
          password_reset.send_password_reset_email
        end
        flash[:info] = "Email sent with password reset instructions"
        redirect_to root_url
      else
        flash.now[:danger] = "Email address not found."
        render "new"
      end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render "edit"
    elsif @user.update(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
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
      unless @user && @user.account_activation.activated? && @user.account_activation.authenticated?(:reset, params[:id])
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_path
      end
    end
end
