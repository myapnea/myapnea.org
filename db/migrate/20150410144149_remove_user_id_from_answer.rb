class RemoveUserIdFromAnswer < ActiveRecord::Migration[4.2]
  def change
    remove_column :answers, :user_id, :integer
  end
end
