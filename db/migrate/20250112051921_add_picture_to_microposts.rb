class AddPictureToMicroposts < ActiveRecord::Migration[8.0]
  def change
    add_column :microposts, :picture, :string
  end
end
