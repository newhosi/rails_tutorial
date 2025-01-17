class CreateLikes < ActiveRecord::Migration[8.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :micropost, null: false, foreign_key: true, index: true
      t.datetime :like_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    add_index :likes, [ :user_id, :micropost_id ], unique: true
  end
end
