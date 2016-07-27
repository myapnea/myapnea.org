class AddNewUniqueIndexToAnswers < ActiveRecord::Migration[4.2]
  def change
    add_index :answers, [:answer_session_id, :question_id], unique: true
  end
end
