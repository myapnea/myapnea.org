class AddSocialFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :experience, :text
    add_column :users, :device, :string
  end
end
