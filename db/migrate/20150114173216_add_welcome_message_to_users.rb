class AddWelcomeMessageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :welcome_message, :text
  end
end
