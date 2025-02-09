class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  # TODO: 에러 구분이 잘 가지 않음. 나중에 수정해야할 것 같음.
  # include Error::ErrorHandler
  include SessionsHelper
  include Pagy::Backend

  def not_found!
    raise ActionController::RoutingError, "No route matches #{params[:path]}"
  end

  private
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
