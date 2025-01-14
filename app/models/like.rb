class Like < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  validates :user_id, presence: true
  valieates :micropost_id, presence: true
end
