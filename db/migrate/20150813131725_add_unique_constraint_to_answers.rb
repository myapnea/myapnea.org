class AddUniqueConstraintToAnswers < ActiveRecord::Migration
  def change
    add_index :answers, [:answer_session_id, :question_id, :deleted], unique: true
  end
end
