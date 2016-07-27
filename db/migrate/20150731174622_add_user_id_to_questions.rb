class AddUserIdToQuestions < ActiveRecord::Migration[4.2]
  def change
    add_column :questions, :user_id, :integer
    add_index :questions, :user_id
  end
end
