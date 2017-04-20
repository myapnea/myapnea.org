class RemoveUnusedUserColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :welcome_message, :text
    remove_column :users, :slug, :string
    remove_column :users, :provider_name, :string
    remove_column :users, :provider_id, :integer
    remove_column :users, :year_of_birth, :integer
    remove_column :users, :age, :integer
    remove_column :users, :gender, :string
    remove_column :users, :experience, :text
    remove_column :users, :device, :string
  end
end
