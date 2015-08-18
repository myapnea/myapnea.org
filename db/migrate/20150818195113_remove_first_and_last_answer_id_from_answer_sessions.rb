class RemoveFirstAndLastAnswerIdFromAnswerSessions < ActiveRecord::Migration
  def up
    remove_index :answer_sessions, :first_answer_id
    remove_column :answer_sessions, :first_answer_id
    remove_index :answer_sessions, :last_answer_id
    remove_column :answer_sessions, :last_answer_id
  end

  def down
    add_column :answer_sessions, :last_answer_id, :integer
    add_index :answer_sessions, :last_answer_id
    add_column :answer_sessions, :first_answer_id, :integer
    add_index :answer_sessions, :first_answer_id
  end
end
