class AddAcceptedUpdateAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :accepted_update_at, :datetime
  end
end
