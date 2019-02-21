class ChangeForeignKeysIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :broadcasts, :category_id, :bigint
    change_column :projects, :slice_site_id, :bigint
    change_column :topic_users, :current_reply_read_id, :bigint
    change_column :topic_users, :last_reply_read_id, :bigint
  end

  def down
    change_column :broadcasts, :category_id, :integer
    change_column :projects, :slice_site_id, :integer
    change_column :topic_users, :current_reply_read_id, :integer
    change_column :topic_users, :last_reply_read_id, :integer
  end
end
