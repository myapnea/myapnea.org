class AddPhotoToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :photo, :string
  end
end
