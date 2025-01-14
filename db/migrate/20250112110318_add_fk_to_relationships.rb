class AddFkToRelationships < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :relationships, :users, column: :follower_id, on_delete: :cascade
    add_foreign_key :relationships, :users, column: :followed_id, on_delete: :cascade
  end
end
