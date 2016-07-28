class DropNotifications < ActiveRecord::Migration[4.2]
  def up
    drop_table :notifications
  end

  def down
    create_table :notifications do |t|
      t.string   :title, null: false
      t.text     :body, null: false
      t.string   :state, default: 'draft', null: false
      t.integer  :comments_count, default: 0, null: false
      t.integer  :user_id
      t.string   :post_type
      t.string   :author
      t.text     :introduction
      t.boolean  :deleted, default: false, null: false
      t.timestamps null: false
    end
  end
end
