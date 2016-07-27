class AddVoteQuotaToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :vote_quota, :integer, default: 5;



  end
end
