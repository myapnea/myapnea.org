class AddDeletableToModels < ActiveRecord::Migration
  def change
    add_column :users, :deleted, :boolean, null: false, default: false
    add_column :answers, :deleted, :boolean, null: false, default: false
    add_column :answer_sessions, :deleted, :boolean, null: false, default: false
    add_column :answer_values, :deleted, :boolean, null: false, default: false
    add_column :social_profiles, :deleted, :boolean, null: false, default: false
    add_column :research_topics, :deleted, :boolean, null: false, default: false
    add_column :comments, :deleted, :boolean, null: false, default: false
    add_column :notifications, :deleted, :boolean, null: false, default: false

  end
end
