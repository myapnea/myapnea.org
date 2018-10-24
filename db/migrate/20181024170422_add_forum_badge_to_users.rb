class AddForumBadgeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :forum_badge, :string
  end
end
