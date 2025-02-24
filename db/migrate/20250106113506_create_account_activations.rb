class CreateAccountActivations < ActiveRecord::Migration[8.0]
  def change
    create_table :account_activations, id: false do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :activation_digest, null: true
      t.boolean :activated, default: false, null: false
      t.datetime :activated_at

      t.timestamps
    end
  end
end
