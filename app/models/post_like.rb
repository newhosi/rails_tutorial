# == Schema Information
#
# Table name: post_likes
#
#  like_at      :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  micropost_id :bigint           not null, primary key
#  user_id      :bigint           not null, primary key
#
# Indexes
#
#  index_post_likes_on_micropost_id  (micropost_id)
#  index_post_likes_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (micropost_id => microposts.id)
#  fk_rails_...  (user_id => users.id)
#
class PostLike < ApplicationRecord
  self.primary_key = [ :user_id, :micropost_id ]
  belongs_to :user
  belongs_to :micropost

  validates :user_id, presence: true
  validates :micropost_id, presence: true
end
