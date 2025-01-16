module LikesHelper
  def like_for(user, micropost)
    user.likes.find_by(micropost: micropost)
  end
end
