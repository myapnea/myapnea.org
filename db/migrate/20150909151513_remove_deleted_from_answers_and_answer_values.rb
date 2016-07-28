class RemoveDeletedFromAnswersAndAnswerValues < ActiveRecord::Migration[4.2]
  def up
    remove_index :answers, [:answer_session_id, :question_id, :deleted]
    remove_index :answers, :deleted
    remove_column :answers, :deleted
    remove_column :answer_values, :deleted
  end

  def down
    add_column :answer_values, :deleted, :boolean, null: false, default: false
    add_column :answers, :deleted, :boolean, null: false, default: false
    add_index :answers, :deleted
    add_index :answers, [:answer_session_id, :question_id, :deleted], unique: true
  end
end
