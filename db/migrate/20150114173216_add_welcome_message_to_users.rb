class AddWelcomeMessageToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :welcome_message, :text
  end
end
