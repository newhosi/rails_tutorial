module ApplicationHelper
  include Pagy::Frontend

  def full_title(page_title = "")
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def new_micropost
    if logged_in?
      @micropost = current_user.microposts.build
    else
    end
  end
end
