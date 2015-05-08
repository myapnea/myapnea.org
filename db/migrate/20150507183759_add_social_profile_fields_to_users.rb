class AddSocialProfileFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :forum_name, :string
    add_column :users, :age, :integer
    add_column :users, :gender, :string
  end
end
