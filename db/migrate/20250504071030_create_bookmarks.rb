class CreateBookmarks < ActiveRecord::Migration[8.0]
  def change
    create_table :bookmarks, primary_key: [ :user_id, :micropost_id ] do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :micropost, null: false, foreign_key: true, index: true

      t.timestamp :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
