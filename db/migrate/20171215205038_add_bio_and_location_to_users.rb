class AddBioAndLocationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :profile_bio, :string
    add_column :users, :profile_location, :string
  end
end
