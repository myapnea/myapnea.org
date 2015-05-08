class AddDeletableToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :deleted, :boolean, null: false, default: false
  end
end
