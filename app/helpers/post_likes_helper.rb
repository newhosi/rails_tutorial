module PostLikesHelper
  def like_for(user, micropost)
    user.post_likes.find_by(micropost: micropost)
  end
end
