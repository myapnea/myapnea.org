class RemoveForemTables < ActiveRecord::Migration
  def up
    drop_table :forem_categories
    drop_table :forem_forums
    drop_table :forem_groups
    drop_table :forem_memberships
    drop_table :forem_moderator_groups
    drop_table :forem_posts
    drop_table :forem_subscriptions
    drop_table :forem_topics
    drop_table :forem_views
    remove_column :users, :forem_admin
    remove_column :users, :forem_state
    remove_column :users, :forem_auto_subscribe
  end

  def down
    add_column :users, :forem_auto_subscribe, :boolean, default: false
    add_column :users, :forem_state, :string, default: 'pending_review'
    add_column :users, :forem_admin, :boolean, default: false
    create_table :forem_views
    create_table :forem_topics
    create_table :forem_subscriptions
    create_table :forem_posts
    create_table :forem_moderator_groups
    create_table :forem_memberships
    create_table :forem_groups
    create_table :forem_forums
    create_table :forem_categories
  end
end
