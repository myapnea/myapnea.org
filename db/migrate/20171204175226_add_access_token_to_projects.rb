class AddAccessTokenToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :access_token, :string
  end
end
