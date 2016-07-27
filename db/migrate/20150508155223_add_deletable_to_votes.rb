class AddDeletableToVotes < ActiveRecord::Migration[4.2]
  def change
    add_column :votes, :deleted, :boolean, null: false, default: false
  end
end
