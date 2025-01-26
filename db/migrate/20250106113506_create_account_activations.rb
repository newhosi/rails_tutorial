class CreateAccountActivations < ActiveRecord::Migration[8.0]
  def change
    create_table :account_activations, primary_key: "user_id" do |t|
      t.references :users, null: false, foreign_key: true, index: true
      t.string :activation_digest, :string, null: false
      t.boolean :activated, default: false, null: false
      t.datetime :activated_at

      t.timestamps
    end
  end
end
