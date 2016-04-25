class AddCommunityContributorToUser < ActiveRecord::Migration
  def change
    add_column :users, :community_contributor, :boolean, null: false, default: false
    add_index :users, :community_contributor
  end
end
