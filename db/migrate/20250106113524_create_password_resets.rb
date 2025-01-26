class CreatePasswordResets < ActiveRecord::Migration[8.0]
  def change
    create_table :password_resets do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :reset_digest, null: false
      t.datetime :reset_sent_at, null: false

      t.timestamps
    end
  end
end
