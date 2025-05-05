module MicropostsHelper
  def bookmark_count_tag(micropost)
    count = micropost.bookmarks.count
    return if count.zero?

    tag.div "#{count}", class: "text-xs text-slate-400"
  end

  def like_count_tag(micropost)
    count = micropost.post_likes.count
    return if count.zero?

    tag.div "#{count}", class: "text-xs text-slate-400"
  end
end
