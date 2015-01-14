class TempFix < ActiveRecord::Migration
  def change
    add_column :forem_topics, :deleted, :boolean, nil: false, default: false
    add_column :forem_posts, :deleted, :boolean, nil: false, default: false

  end
end
