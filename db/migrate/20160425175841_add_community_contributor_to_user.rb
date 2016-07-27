class AddCommunityContributorToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :community_contributor, :boolean, null: false, default: false
    add_index :users, :community_contributor
  end
end
