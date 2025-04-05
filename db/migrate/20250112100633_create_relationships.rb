class CreateRelationships < ActiveRecord::Migration[8.0]
  def change
    create_table :relationships do |t|
      t.bigint :follower_id, null: false
      t.bigint :followed_id, null: false

      t.timestamps
    end

    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, [ :follower_id, :followed_id ], unique: true
    add_foreign_key :relationships, :users, column: :follower_id, on_delete: :cascade
    add_foreign_key :relationships, :users, column: :followed_id, on_delete: :cascade
  end
end
