class AddAcceptedUpdateAtToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :accepted_update_at, :datetime
  end
end
