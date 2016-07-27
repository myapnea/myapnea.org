class AddUniqueIndexToAnswerSession < ActiveRecord::Migration[4.2]
  def change
    add_index :answer_sessions, [:survey_id, :encounter, :user_id, :child_id, :deleted], unique: true, name: 'answer_sessions_idx'
  end
end
