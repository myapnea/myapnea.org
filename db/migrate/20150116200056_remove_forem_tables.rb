class RemoveForemTables < ActiveRecord::Migration[4.2]
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
    create_table :forem_views do |t|
      t.integer :user_id
      t.integer :viewable_id
      t.integer :count, default: 0
      t.string :viewable_type
      t.datetime :current_viewed_at
      t.datetime :past_viewed_at
      t.datetime :created_at
      t.datetime :updated_at
    end
    add_index :forem_views, :updated_at
    add_index :forem_views, :user_id
    add_index :forem_views, :viewable_id

    create_table :forem_topics do |t|
      t.integer :forum_id
      t.integer :user_id
      t.string :subject
      t.boolean :locked, default: false, null: false
      t.boolean :pinned, default: false
      t.boolean :hidden, default: false
      t.datetime :last_post_at
      t.string :state, default: 'pending_review'
      t.integer :views_count, default: 0
      t.string :slug
      t.timestamps
    end
    add_index :forem_topics, :forum_id
    add_index :forem_topics, :slug, unique: true
    add_index :forem_topics, :state
    add_index :forem_topics, :user_id

    create_table :forem_subscriptions do |t|
      t.integer :subscriber_id
      t.integer :topic_id
    end

    create_table :forem_posts do |t|
      t.integer :topic_id
      t.text :text
      t.integer :user_id
      t.integer :reply_to_id
      t.string :state, default: 'pending_review'
      t.boolean :notified, default: false
      t.timestamps
    end
    add_index :forem_posts, :reply_to_id
    add_index :forem_posts, :state
    add_index :forem_posts, :topic_id
    add_index :forem_posts, :user_id

    create_table :forem_moderator_groups do |t|
      t.integer :forum_id
      t.integer :group_id
    end
    add_index :forem_moderator_groups, :forum_id

    create_table :forem_memberships do |t|
      t.integer :group_id
      t.integer :member_id
    end
    add_index :forem_memberships, :group_id

    create_table :forem_groups do |t|
      t.string :name
    end
    add_index :forem_groups, :name

    create_table :forem_forums do |t|
      t.string :name
      t.text :description
      t.integer :category_id
      t.integer :views_count, default: 0
      t.string :slug
    end
    add_index :forem_forums, :slug, unique: true

    create_table :forem_categories do |t|
      t.string :name, null: false
      t.string :slug
      t.timestamps
    end
    add_index :forem_categories, :slug, unique: true
  end
end
