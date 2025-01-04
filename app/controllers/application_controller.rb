class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  include SessionsHelper

  include Pagy::Backend
end
