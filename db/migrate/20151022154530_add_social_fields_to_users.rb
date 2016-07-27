class AddSocialFieldsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :experience, :text
    add_column :users, :device, :string
  end
end
