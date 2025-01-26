class Like < ApplicationRecord
  self.primary_key = [ :user_id, :micropost_id ]
  belongs_to :user
  belongs_to :micropost

  validates :user_id, presence: true
  validates :micropost_id, presence: true
end
