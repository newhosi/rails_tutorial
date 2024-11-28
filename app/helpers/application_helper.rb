module ApplicationHelper
  # 각 페이지 당 완전한 페이지 타이틀을 리턴함.
  def full_title(page_title = "")
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
