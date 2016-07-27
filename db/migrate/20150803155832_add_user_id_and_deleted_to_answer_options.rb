class AddUserIdAndDeletedToAnswerOptions < ActiveRecord::Migration[4.2]
  def change
    add_column :answer_options, :user_id, :integer
    add_column :answer_options, :deleted, :boolean, null: false, default: false
    add_index :answer_options, :user_id
    add_index :answer_options, :deleted
  end
end
