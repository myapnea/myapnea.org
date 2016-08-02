class RemoveVoteQuotaFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :vote_quota, :integer, default: 5
  end
end
