class HomesController < ApplicationController
  def home
    if logged_in?
      @pagy, @microposts = pagy(Micropost.all, limit: 9)
    end
  end
end
