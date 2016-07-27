class CreateAnswerSessions < ActiveRecord::Migration[4.2]
  def change
    create_table :answer_sessions do |t|
      t.references :user
      t.references :question_flow
      t.integer :first_answer_id
      t.integer :last_answer_id

      t.timestamps
    end
  end
end
