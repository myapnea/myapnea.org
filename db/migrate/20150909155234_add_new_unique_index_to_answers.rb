class AddNewUniqueIndexToAnswers < ActiveRecord::Migration
  def change
    add_index :answers, [:answer_session_id, :question_id], unique: true
  end
end
